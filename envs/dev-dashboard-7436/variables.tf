variable "aws_region" {
  description = "AWSリージョン"
  type        = string
}

variable "profile" {
  description = "AWSプロファイル名"
  type        = string
}

variable "env" {
  description = "実行環境名（例:dev/stg/prod）"
  type        = string
}

variable "service_name" {
  description = "サービス名（リソースにつけているプレフィックス名）"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名（カスタムダッシュボードの名前）"
  type        = string
}