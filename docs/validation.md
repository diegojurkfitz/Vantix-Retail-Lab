# Validação — Vantix Retail Cloud Lab (Bloco 4)

> Documento de evidências operacionais. Contém Account ID e IDs de recursos
> propositalmente fora do README público.

## Contexto de execução

| Item | Valor |
|------|-------|
| Account ID | `473247068706` |
| ARN | `arn:aws:iam::473247068706:user/terraform-lab` |
| Profile | `terraform-lab` (`AWS_PROFILE` neutralizado na sessão) |
| Região | `us-east-1` |
| Terraform | v1.13.5 |
| AWS CLI | 2.32.6 |
| Provider AWS | 5.100.0 |
| Trava de conta | `allowed_account_ids = ["473247068706"]` |

## Pipeline executado

| Etapa | Resultado |
|-------|-----------|
| `terraform fmt -recursive` | exit 0 (sem alterações) |
| `terraform init` | sucesso (aws 5.100.0, random 3.9.0, archive 2.8.0) |
| `terraform validate` | `Success! The configuration is valid.` |
| `terraform plan` | `Plan: 13 to add, 0 to change, 0 to destroy` |
| `terraform apply "lab.tfplan"` | `Apply complete! Resources: 13 added, 0 changed, 0 destroyed` |

## Outputs

| Output | Valor |
|--------|-------|
| account_id | `473247068706` |
| region | `us-east-1` |
| vpc_id | `vpc-01aada4390b333cf0` |
| subnet_id | `subnet-0a670fa964b3ec081` |
| route_table_id | `rtb-0372a309f6b09e529` |
| s3_bucket_name | `vantix-retail-cloud-lab-lab-07f8c397` |
| iam_role_arn | `arn:aws:iam::473247068706:role/vantix-retail-cloud-lab-lab-lambda-role` |
| lambda_function_name | `vantix-retail-cloud-lab-lab-fn` |

## Validações via AWS CLI (somente consulta)

### VPC
- `vpc-01aada4390b333cf0`, CIDR `10.0.0.0/16`, State `available`.

### Subnet
- `subnet-0a670fa964b3ec081`, CIDR `10.0.1.0/24`, AZ `us-east-1a`, `MapPublicIpOnLaunch=false`.

### Route Table
- `rtb-0372a309f6b09e529`, única rota `10.0.0.0/16 -> local` (sem `0.0.0.0/0`, ou seja, sem IGW/NAT). Associada à subnet.

### S3
- Bucket `vantix-retail-cloud-lab-lab-07f8c397`.
- Public Access Block: `BlockPublicAcls`, `IgnorePublicAcls`, `BlockPublicPolicy`, `RestrictPublicBuckets` = **true**.
- Criptografia: `AES256` (SSE-S3), `BucketKeyEnabled=true`.
- `KeyCount = null` (bucket **vazio**).

### IAM
- Role `vantix-retail-cloud-lab-lab-lambda-role`.
- Managed policies anexadas: **nenhuma** (sem AdministratorAccess/PowerUserAccess).
- Policy inline `...-least-privilege`:
  - `s3:GetObject` em `arn:aws:s3:::vantix-retail-cloud-lab-lab-07f8c397/*`;
  - `logs:CreateLogStream`, `logs:PutLogEvents` no log group `/aws/lambda/vantix-retail-cloud-lab-lab-fn`.

### Lambda
- `vantix-retail-cloud-lab-lab-fn`, runtime `python3.12`, handler `handler.handler`,
  memória 128MB, timeout 10s, State `Active`, `VpcConfig=null` (fora da VPC, intencional).
- **Não invocada** (sem execução/tráfego).

### Terraform state
- 13 recursos gerenciados + 5 data sources = 18 entradas em `terraform state list`.

## Custo
- Nenhum recurso com cobrança horária de infraestrutura foi criado.
- S3 vazio, Lambda não invocada, CloudWatch sem logs (retenção 1 dia).
- Objetivo de custo R$ 0; custo efetivo depende das condições de cobrança da conta.

## Destroy
- (a ser preenchido após `terraform destroy`).
