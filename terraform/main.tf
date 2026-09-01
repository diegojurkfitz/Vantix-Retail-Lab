# main.tf concentra dados de contexto usados pelos demais arquivos.
# A criação de recursos está separada por domínio: network.tf, s3.tf,
# iam.tf e compute.tf, para legibilidade e coerência organizacional.

# Confirmação da identidade efetiva usada pelo provider (consulta).
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
