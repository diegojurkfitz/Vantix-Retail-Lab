# Rede mínima e isolada. Sem Internet Gateway, sem NAT Gateway.
# Demonstra o princípio de isolamento de rede do Bloco 1 a custo zero
# (VPC, subnet e route table não têm cobrança por existência).

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-subnet-private"
    Tier = "private"
  }
}

# Route table sem rota de saída para a internet (apenas a rota "local"
# implícita da VPC). Reforça o isolamento e evita qualquer componente pago.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-rt-private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
