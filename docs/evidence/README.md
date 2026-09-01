# Evidências do Terraform

Saídas reais capturadas durante a execução do laboratório (Bloco 4).

| Arquivo | Etapa |
|---------|-------|
| `01-fmt.txt` | `terraform fmt -check -recursive` (exit 0) |
| `02-validate.txt` | `terraform validate` |
| `03-plan.txt` | `terraform show lab.tfplan` (plano completo, 13 a criar) |
| `04-apply-state-list.txt` | `terraform state list` após o apply |
| `05-outputs.txt` | `terraform output` |
| `06-apply-summary.txt` | Resumo do `terraform apply` (13 added) |
| `07-destroy-summary.txt` | Resumo do `terraform destroy` (13 destroyed) |
| `08-post-destroy-validation.txt` | Validação pós-destroy (state vazio + AWS CLI) |

## Como as evidências se relacionam

O mesmo recurso é comprovado em três camadas complementares:

| Recurso | Evidência Terraform | Output | Validação AWS CLI | Screenshot do console |
|---------|--------------------|--------|-------------------|-----------------------|
| VPC | `03-plan.txt`, `04-apply-state-list.txt` | `vpc_id` (`05-outputs.txt`) | `describe-vpcs` (`../validation.md`) | `../screenshots/*_VPC.png` |
| Subnet | idem | `subnet_id` | `describe-subnets` | `../screenshots/*_Subnet.png` |
| Route Table | idem | `route_table_id` | `describe-route-tables` | `../screenshots/*_Route_Table.png` |
| S3 Bucket | idem | `s3_bucket_name` | `get-public-access-block`, `get-bucket-encryption` | `../screenshots/*_BucketS3.png` |
| IAM Role/Policy | idem | `iam_role_arn` | `get-role`, `get-role-policy` | `../screenshots/*_IAM_Role_Lambda.png` |
| Lambda | idem | `lambda_function_name` | `get-function-configuration` | `../screenshots/*_LAMBDA.png` |
| Identidade / profile | — | `account_id` | `sts get-caller-identity` | `../screenshots/*_Profile_AWS.png` |
| `terraform validate` | `02-validate.txt` | — | — | `../screenshots/*_Terraform_Validate.png` |
| Git | — | — | — | `../screenshots/*_Git_Status.png` |

- Pipeline completo e validações detalhadas: ver `../validation.md`.
- Screenshots do console AWS: `../screenshots/` (38 arquivos, prefixo `vantix-retail-cloud-lab-Evidencia_N_...`).

Evidências de `destroy` e validação pós-destroy: `07-destroy-summary.txt` e `08-post-destroy-validation.txt` (detalhes também em `../validation.md`). Ambiente completamente destruído, sem recursos residuais.
