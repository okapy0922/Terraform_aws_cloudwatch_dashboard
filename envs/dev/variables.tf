variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"  # デフォルト設定
}

variable "profile" {
  description = "AWS profile"
  type        = string
  default     = "dev-backend-dashboad"  # デフォルト設定
}

variable "env" {
  description = "Deployment environment name"
  type        = string
  default     = "dev-dashboad"  # デフォルト設定
}

variable "project_name" {
  description = "Project name for tagging purposes"
  type        = string
  default     = "example-project"  # デフォルト設定
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "example-dynamodb-table"  # デフォルト設定
}

variable "api_gateway_name" {
  description = "API Gateway name"
  type        = string
  default     = "example-api-gateway"  # デフォルト設定
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "example-lambda-function"  # デフォルト設定
}