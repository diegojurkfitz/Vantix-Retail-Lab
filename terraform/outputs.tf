output "account_id" {
  description = "Account ID efetivamente usado (deve ser a conta pessoal)."
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "Região dos recursos."
  value       = data.aws_region.current.name
}

output "vpc_id" {
  description = "ID da VPC do laboratório."
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID da subnet privada."
  value       = aws_subnet.private.id
}

output "route_table_id" {
  description = "ID da route table privada."
  value       = aws_route_table.private.id
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 do laboratório."
  value       = aws_s3_bucket.app.id
}

output "iam_role_arn" {
  description = "ARN da IAM Role da Lambda."
  value       = aws_iam_role.lambda.arn
}

output "lambda_function_name" {
  description = "Nome da função Lambda."
  value       = aws_lambda_function.app.function_name
}
