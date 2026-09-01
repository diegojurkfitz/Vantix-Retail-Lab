variable "aws_region" {
  description = "Região AWS do laboratório."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Profile AWS local (conta pessoal). Nunca usar profile corporativo."
  type        = string
  default     = "terraform-lab"
}

variable "allowed_account_id" {
  description = "Account ID pessoal permitido. Trava contra uso da conta errada."
  type        = string
  default     = "473247068706"
}

variable "project" {
  description = "Nome do projeto (usado em nomes e tags)."
  type        = string
  default     = "vantix-retail-cloud-lab"
}

variable "environment" {
  description = "Ambiente lógico do laboratório."
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Responsável pelos recursos (tag de FinOps/governança)."
  type        = string
  default     = "cloud-architecture"
}

variable "purpose" {
  description = "Finalidade dos recursos (tag)."
  type        = string
  default     = "technical-test"
}

variable "vpc_cidr" {
  description = "CIDR da VPC do laboratório."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR da subnet do laboratório."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "AZ da subnet."
  type        = string
  default     = "us-east-1a"
}

variable "log_retention_days" {
  description = "Retenção dos logs da Lambda. Baixa para manter custo zero."
  type        = number
  default     = 1
}
