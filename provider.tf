terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
  access_key = "AKIA2MD4HZVKPBSEUMXT"
  secret_key = "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"
}

data "aws_availability_zones" "available" {}