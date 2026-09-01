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

## Evidências visuais

Screenshots em `docs/screenshots/` (prefixo `vantix-retail-cloud-lab-`). Foram
capturadas múltiplas evidências (`Evidencia_N_...`) por recurso, cobrindo
diferentes telas/abas do console AWS.

| Evidência | Screenshots | Comprova |
|-----------|-------------|----------|
| Identidade / profile AWS | `Evidencia_1_Profile_AWS.png` | Conta `473247068706` / profile `terraform-lab` |
| `terraform validate` | `Evidencia_1_Terraform_Validate.png` | Configuração válida |
| Git status | `Evidencia_1_Git_Status.png` | Estado do repositório |
| VPC | `Evidencia_1_VPC.png` … `Evidencia_5_VPC.png` | VPC `vpc-01aada4390b333cf0`, CIDR `10.0.0.0/16` |
| Subnet | `Evidencia_1_Subnet.png` … `Evidencia_4_Subnet.png` | Subnet privada `10.0.1.0/24`, us-east-1a |
| Route Table | `Evidencia_1_Route_Table.png` … `Evidencia_5_Route_Table.png` | Rota apenas `local` (sem IGW/NAT) |
| S3 Bucket | `Evidencia_1_BucketS3.png` … `Evidencia_8_BucketS3.png` | Bucket privado, BPA, SSE-S3, vazio |
| IAM Role / Policy | `Evidencia_1_IAM_Role_Lambda.png` … `Evidencia_6_IAM_Role_Lambda.png` | Role + policy least privilege |
| Lambda | `Evidencia_1_LAMBDA.png` … `Evidencia_8_LAMBDA.png` | Função `...-fn`, python3.12, fora da VPC |

> As telas de VPC, subnet, route table, S3, IAM e Lambda mostram nome do
> recurso, região `us-east-1` e configurações relevantes, comprovando o
> provisionamento real do ambiente.

## Custo
- Nenhum recurso com cobrança horária de infraestrutura foi criado.
- S3 vazio, Lambda não invocada, CloudWatch sem logs (retenção 1 dia).
- Objetivo de custo R$ 0; custo efetivo depende das condições de cobrança da conta.

## Destroy
- (a ser preenchido após `terraform destroy`).
