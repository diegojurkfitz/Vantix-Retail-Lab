"""Função de demonstração do laboratório Vantix Retail Cloud Lab.

Representa o compute da arquitetura do Bloco 1 de forma mínima:
- lê o nome do bucket a partir de variável de ambiente (sem segredos);
- tenta ler um objeto de exemplo do bucket usando apenas s3:GetObject
  (least privilege). Se o objeto não existir, retorna a informação sem
  falhar, pois o bucket é mantido vazio para custo zero.

Não faz laços, não gera tráfego contínuo e não deve ser invocada
repetidamente.
"""

import os

import boto3
from botocore.exceptions import ClientError

s3 = boto3.client("s3")


def handler(event, context):
    bucket = os.environ.get("BUCKET_NAME", "")
    key = "example.txt"

    result = {
        "bucket": bucket,
        "requested_key": key,
    }

    try:
        obj = s3.get_object(Bucket=bucket, Key=key)
        result["status"] = "object_found"
        result["length"] = obj["ContentLength"]
    except ClientError as exc:
        code = exc.response.get("Error", {}).get("Code", "Unknown")
        # NoSuchKey é esperado: o bucket é mantido vazio no laboratório.
        result["status"] = "no_object"
        result["error_code"] = code

    return result
