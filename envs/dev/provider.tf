# Provider configuration
provider "aws" {
  region  = var.region   # ダッシュボードを作成するAWSリージョンを指定
  profile = var.profile  # 使用するAWSプロファイルを指定
  env = var.env          # 環境識別
}

terraform {
  required_version = "~> 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # AWSプロバイダーのバージョン要確認
    }
  }
}