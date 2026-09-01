# Compute via AWS Lambda: sem cobrança por ociosidade.
# A função NÃO é anexada à VPC de propósito: em subnet privada sem NAT
# nem VPC Endpoint ela não teria egress, e criar NAT/endpoint fugiria da
# premissa de custo zero. A VPC demonstra isolamento de rede de forma
# independente; a Lambda acessa S3 pela rede gerenciada da AWS.

# Empacota o código-fonte em zip (data source, sem custo).
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_src"
  output_path = "${path.module}/build/lambda.zip"
}

# Log group criado explicitamente para controlar a retenção (custo).
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.name_prefix}-fn"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${local.name_prefix}-fn-logs"
  }
}

resource "aws_lambda_function" "app" {
  function_name = "${local.name_prefix}-fn"
  role          = aws_iam_role.lambda.arn
  runtime       = "python3.12"
  handler       = "handler.handler"
  timeout       = 10
  memory_size   = 128

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # Passa o nome do bucket para o código sem expor segredos.
  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.app.id
    }
  }

  # Garante que a policy de logs exista antes da função.
  depends_on = [
    aws_iam_role_policy.lambda,
    aws_cloudwatch_log_group.lambda,
  ]

  tags = {
    Name = "${local.name_prefix}-fn"
  }
}
