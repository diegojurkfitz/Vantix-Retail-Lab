locals {
  # Prefixo curto e previsível para nomear recursos.
  name_prefix = "${var.project}-${var.environment}"

  # Conjunto mínimo e consistente de tags (coerente com FinOps do Bloco 2).
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
    Purpose     = var.purpose
  }
}
