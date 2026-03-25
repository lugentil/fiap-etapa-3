package main

import (
	"crypto/sha256"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"
)

const (
	CACHE_TTL = 30 * time.Second
)

func sanitize(s string) string {
	return strings.NewReplacer("\n", "", "\r", "", "\t", "").Replace(s)
}

func (a *App) getDecision(userID, flagName string) (bool, error) {
	info, err := a.getCombinedFlagInfo(flagName)
	if err != nil {
		return false, err
	}
	return a.runEvaluationLogic(info, userID), nil
}

func (a *App) getCombinedFlagInfo(flagName string) (*CombinedFlagInfo, error) {
	cacheKey := fmt.Sprintf("flag_info:%s", sanitize(flagName))

	val, err := a.RedisClient.Get(ctx, cacheKey).Result()
	if err == nil {
		var info CombinedFlagInfo
		if unmarshalErr := json.Unmarshal([]byte(val), &info); unmarshalErr == nil {
			log.Printf("Cache HIT para flag '%s'", sanitize(flagName))
			return &info, nil
		} else {
			log.Printf("Erro ao desserializar cache para flag '%s': %v", sanitize(flagName), unmarshalErr)
		}
	}

	log.Printf("Cache MISS para flag '%s'", sanitize(flagName))
	info, err := a.fetchFromServices(flagName)
	if err != nil {
		return nil, err
	}

	jsonData, err := json.Marshal(info)
	if err == nil {
		if err := a.RedisClient.Set(ctx, cacheKey, jsonData, CACHE_TTL).Err(); err != nil {
			log.Printf("Erro ao salvar cache para flag: %v", err)
		}
	}

	return info, nil
}

func (a *App) fetchFromServices(flagName string) (*CombinedFlagInfo, error) {
	var wg sync.WaitGroup
	wg.Add(2)

	var flagInfo *Flag
	var ruleInfo *TargetingRule
	var flagErr, ruleErr error

	go func() {
		defer wg.Done()
		flagInfo, flagErr = a.fetchFlag(flagName)
	}()

	go func() {
		defer wg.Done()
		ruleInfo, ruleErr = a.fetchRule(flagName)
	}()

	wg.Wait()

	if flagErr != nil {
		return nil, flagErr
	}
	if ruleErr != nil {
		log.Printf("Aviso: Nenhuma regra de segmentacao encontrada para '%s'. Usando padrao.", sanitize(flagName))
	}

	return &CombinedFlagInfo{
		Flag: flagInfo,
		Rule: ruleInfo,
	}, nil
}

func buildServiceURL(baseURL, path string) (string, error) {
	u, err := url.Parse(baseURL)
	if err != nil {
		return "", fmt.Errorf("URL base invalida: %w", err)
	}
	u.Path = path
	return u.String(), nil
}

func (a *App) fetchFlag(flagName string) (*Flag, error) {
	requestURL, err := buildServiceURL(a.FlagServiceURL, "/flags/"+url.PathEscape(flagName))
	if err != nil {
		return nil, err
	}

	req, err := http.NewRequest("GET", requestURL, nil)
	if err != nil {
		return nil, fmt.Errorf("erro ao criar request para flag-service: %w", err)
	}
	req.Header.Set("Authorization", "Bearer "+a.ServiceAPIKey)

	resp, err := a.HttpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("erro ao chamar flag-service: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, &NotFoundError{flagName}
	}
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("flag-service retornou status %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("erro ao ler resposta do flag-service: %w", err)
	}
	var flag Flag
	if err := json.Unmarshal(body, &flag); err != nil {
		return nil, fmt.Errorf("erro ao desserializar resposta do flag-service: %w", err)
	}
	return &flag, nil
}

func (a *App) fetchRule(flagName string) (*TargetingRule, error) {
	requestURL, err := buildServiceURL(a.TargetingServiceURL, "/rules/"+url.PathEscape(flagName))
	if err != nil {
		return nil, err
	}

	req, err := http.NewRequest("GET", requestURL, nil)
	if err != nil {
		return nil, fmt.Errorf("erro ao criar request para targeting-service: %w", err)
	}
	req.Header.Set("Authorization", "Bearer "+a.ServiceAPIKey)

	resp, err := a.HttpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("erro ao chamar targeting-service: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusNotFound {
		return nil, &NotFoundError{flagName}
	}
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("targeting-service retornou status %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("erro ao ler resposta do targeting-service: %w", err)
	}
	var rule TargetingRule
	if err := json.Unmarshal(body, &rule); err != nil {
		return nil, fmt.Errorf("erro ao desserializar resposta do targeting-service: %w", err)
	}
	return &rule, nil
}

func (a *App) runEvaluationLogic(info *CombinedFlagInfo, userID string) bool {
	if info.Flag == nil || !info.Flag.IsEnabled {
		return false
	}

	if info.Rule == nil || !info.Rule.IsEnabled {
		return true
	}

	rule := info.Rule.Rules
	if rule.Type == "PERCENTAGE" {
		percentage, ok := rule.Value.(float64)
		if !ok {
			log.Printf("Erro: valor da regra de porcentagem nao e um numero para a flag '%s'", sanitize(info.Flag.Name))
			return false
		}

		userBucket := getDeterministicBucket(userID + info.Flag.Name)

		if float64(userBucket) < percentage {
			return true
		}
	}

	return false
}

func getDeterministicBucket(input string) int {
	hasher := sha256.New()
	hasher.Write([]byte(input))
	hash := hasher.Sum(nil)
	val := binary.BigEndian.Uint32(hash[:4])
	return int(val % 100)
}
