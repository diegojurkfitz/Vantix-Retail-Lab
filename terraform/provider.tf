# Profile e região são passados por variáveis para evitar uso acidental
# de credenciais/perfis corporativos. O profile pessoal "terraform-lab"
# é o default definido em variables.tf.
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  # Trava de segurança: o apply/plan falha se a identidade efetiva não
  # for exatamente a conta pessoal informada para o laboratório.
  allowed_account_ids = [var.allowed_account_id]

  default_tags {
    tags = local.common_tags
  }
}
