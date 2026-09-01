# Bucket S3 privado, criptografado e sem objetos.
# Nome único via sufixo aleatório (nomes de bucket são globais).
# Sem objetos e sem tráfego => custo efetivo zero.

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app" {
  bucket        = "${local.name_prefix}-${random_id.bucket_suffix.hex}"
  force_destroy = true # permite destroy limpo no fim do laboratório

  tags = {
    Name = "${local.name_prefix}-bucket"
  }
}

# Bloqueio total de acesso público.
resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Ownership enforced: desabilita ACLs, o dono da conta controla os objetos.
resource "aws_s3_bucket_ownership_controls" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Criptografia padrão SSE-S3 (AES256) — gerenciada pela AWS, sem custo de KMS.
resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}
