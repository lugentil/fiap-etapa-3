resource "aws_elasticache_serverless_cache" "redis_tech_challenge" {
  engine = "valkey"
  name   = var.redis_name
  cache_usage_limits {
    data_storage {
      maximum = 10
      unit    = "GB"
    }
    ecpu_per_second {
      maximum = 5000
    }
  }
  description              = "Vaulkey para o TechChallenge"
  major_engine_version     = var.major_engine_version
  subnet_ids               = var.subnet_ids

 # security_group_ids       = [aws_security_group.test.id]
}