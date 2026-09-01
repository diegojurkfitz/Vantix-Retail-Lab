# AWS Cloud Lab — Vantix Retail

## Objetivo

Laboratório do Bloco 4. Implementa **uma pequena parte** da arquitetura de checkout proposta no Bloco 1, com foco em qualidade técnica, segurança e **objetivo de custo R$ 0** — não em reproduzir o ambiente de produção.

## O que foi construído

- 1 VPC isolada (`10.0.0.0/16`), sem Internet/NAT Gateway
- 1 subnet privada (`10.0.1.0/24`) + route table (apenas rota local)
- 1 bucket S3 privado (Block Public Access, SSE-S3, ownership enforced, sem objetos)
- 1 IAM Role + policy inline **least privilege** (só `s3:GetObject` no bucket + logs da função)
- 1 função Lambda (Python 3.12) como compute, sem cobrança por ociosidade
- 1 CloudWatch Log Group (retenção de 1 dia)
- Tags padronizadas em todos os recursos

## Arquitetura

`IAM Role (least privilege) → Lambda (compute) → S3 (storage)`, com **VPC isolada** demonstrando segmentação de rede.

A **Lambda permanece fora da VPC de forma intencional**: a VPC, a subnet e a route table existem para demonstrar o isolamento de rede, enquanto a função acessa o S3 pela rede gerenciada da AWS. Colocá-la na subnet privada exigiria **NAT Gateway** (para egress) ou **VPC Endpoint** — ambos evitados para manter o laboratório mínimo e sem custo.

## Por que essas escolhas

- **Terraform**: IaC reprodutível e versionada.
- **Isolamento**: VPC/subnet/route table representam o princípio de rede do Bloco 1 sem recursos pagos.
- **IAM least privilege**: permissões restritas a serviço, ação e recurso específicos.
- **Compute (Lambda)**: sem custo de ociosidade, ideal para um lab que não precisa de capacidade permanente.
- **S3**: storage de objetos privado e criptografado, mantido vazio.
- **Tags**: governança e FinOps (Bloco 2).
- **Objetivo de custo R$ 0 / simplicidade**: menor conjunto de recursos capaz de demonstrar os conceitos.

## Segurança

- IAM least privilege (sem `AdministratorAccess`/`PowerUserAccess`/`*:*`).
- S3 com Block Public Access total, SSE-S3 e ownership enforced.
- Provider travado por `allowed_account_ids` (conta pessoal).
- Sem credenciais, secrets ou tokens no código; nome do bucket passado por env var.

## FinOps

- **Objetivo de custo: R$ 0.** O laboratório não utiliza recursos com cobrança horária de infraestrutura. Serviços com cobrança por uso serão mantidos sem armazenamento, tráfego ou execução desnecessária. O custo efetivo depende das condições de cobrança da conta AWS.
- Sem NAT Gateway, ALB/NLB, EC2, RDS, ElastiCache e demais recursos pagos.
- Ambiente mínimo, bucket vazio e Lambda não invocada em loop.
- Tags de custo e **destruição após os testes** (`terraform destroy`).

## O que faltaria para produção (Bloco 1)

ALB, ECS/Fargate, múltiplas AZs, RDS PostgreSQL Multi-AZ, RDS Proxy, ElastiCache, SQS, WAF, CloudFront, Secrets Manager, observabilidade (OpenTelemetry), autoscaling e DR / Warm Standby.
