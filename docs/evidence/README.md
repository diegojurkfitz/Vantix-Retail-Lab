# Evidências do Terraform

Saídas reais capturadas durante a execução do laboratório (Bloco 4).

| Arquivo | Etapa |
|---------|-------|
| `01-fmt.txt` | `terraform fmt -check -recursive` (exit 0) |
| `02-validate.txt` | `terraform validate` |
| `03-plan.txt` | `terraform show lab.tfplan` (plano completo, 13 a criar) |
| `04-apply-state-list.txt` | `terraform state list` após o apply |
| `05-outputs.txt` | `terraform output` |
| `06-apply-summary.txt` | Resumo do `terraform apply` |

As evidências de `destroy` e a validação pós-destroy serão adicionadas ao final do laboratório.
Screenshots do console AWS ficam em `../screenshots/`.
