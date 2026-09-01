# IAM com least privilege. A role é assumida apenas pela Lambda.
# A policy inline concede exclusivamente:
#   - s3:GetObject no bucket específico (leitura de objetos do lab);
#   - logs mínimos no CloudWatch para a função (grupo específico).
# Sem AdministratorAccess, sem PowerUserAccess, sem "*:*".

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    sid     = "AllowLambdaServiceAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Name = "${local.name_prefix}-lambda-role"
  }
}

# Least privilege explícito: apenas leitura de objetos no bucket do lab
# e escrita de logs no grupo de log específico da função.
data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    sid       = "ReadObjectsFromLabBucket"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.app.arn}/*"]
  }

  statement {
    sid     = "WriteFunctionLogs"
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "${aws_cloudwatch_log_group.lambda.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda" {
  name   = "${local.name_prefix}-lambda-least-privilege"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_permissions.json
}
