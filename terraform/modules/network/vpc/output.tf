output "vpc_id" {
  description = "ID da VPC criada para o Tech Challenge"
  value = aws_vpc.tech_challenge.id
}