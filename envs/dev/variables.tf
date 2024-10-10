variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"  # デフォルト設定をここに設定しておくことも可能、、dev.tfvarsで上書きされる
}

variable "profile" {
  description = "AWSプロファイル名"
  type        = string
  default     = "default"  # デフォルト設定（必要に応じて変更）
}

variable "env" {
  description = "Deployment environment name"
  type        = string
  default     = "dev-dashboad"  # デフォルト設定
}

variable "project_name" {
  description = "Project name for tagging purposes"
  type        = string
  default     = "Dev-dashboad"  # デフォルト設定
}

variable "dynamodb_table_name" {
  description = "DynamoDB table names"
  type        = list(string)  # リスト型
  default     = []  # 空のリストをデフォルトとして設定（必要に応じて）
}

variable "api_gateway_name" {
  description = "API Gateway names"
  type        = list(string)  # リスト型
  default     = []  # 空のリストをデフォルトとして設定（必要に応じて）
}