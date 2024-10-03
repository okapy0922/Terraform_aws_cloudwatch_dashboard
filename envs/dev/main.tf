# 現在のAWSアカウントIDを取得
data "aws_caller_identity" "current" {}

# ローカル変数
locals {
  prefix = var.env
  tags = {
    Environment = var.env
    Project     = var.project_name
  }
}

# DynamoDB、API Gateway、LambdaのCloudWatchダッシュボード
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${local.prefix}-services-dashboard"

 dashboard_body = jsonencode({
    widgets = [
      # DynamoDBのメトリクス 読み取り/書き込み 使用量
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 3,
        "x"      = 0,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            [ "AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.dynamodb_table_name ],
            [ "AWS/DynamoDB", "ConsumedWriteCapacityUnits", "TableName", var.dynamodb_table_name ],
            [ "AWS/DynamoDB", "ProvisionedReadCapacityUnits", "TableName", var.dynamodb_table_name ],
            [ "AWS/DynamoDB", "ProvisionedWriteCapacityUnits", "TableName", var.dynamodb_table_name ]
          ],
          "region" = var.aws_region
        }
      },
      # DynamoDB アイテムカウント（クエリ操作によって返されたアイテム数）
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 3,
        "x"      = 12,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            [ "AWS/DynamoDB", "ReturnedItemCount", "TableName", var.dynamodb_table_name, "Operation", "Query" ]
          ],
          "region" = var.aws_region
        }
      },
      # DynamoDB リクエストの処理に経過した時間
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 3,
        "x"      = 18,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", var.dynamodb_table_name, "Operation", "Query" ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", var.dynamodb_table_name, , "UpdateItem" ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", var.dynamodb_table_name, , "PutItem" ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", var.dynamodb_table_name, , "GetItem" ]
          ],
          "region" = var.aws_region
        }
      },
      {
        "height" = 3,
        "width"  = 24,
        "y"      = 0,
        "x"      = 0,
        "type"   = "text",
        "properties" = {
          "markdown"    = "# DynamoDB\n- 消費Capacity Unit\n- 消費Capacity Unit for GSI\n- Return Count\n- Latency\n",
          "background"  = "transparent"
        }
      },
      {
        "height" = 2,
        "width"  = 24,
        "y"      = 9,
        "x"      = 0,
        "type"   = "text",
        "properties" = {
          "markdown"    = "# Lambda\n- 実行時間\n- 実行回数",
          "background"  = "transparent"
        }
      },
      # Lambdaの実行時間メトリクス
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 11,
        "x"      = 0,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            [ "AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name ]
          ],
          "region" = var.aws_region
        }
      },
      # Lambdaの同時実行数メトリクス
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 11,
        "x"      = 6,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            [ "AWS/Lambda", "ConcurrentExecutions" ],
            [ "AWS/Lambda", "UnreservedConcurrentExecutions" ]
          ],
          "region" = var.aws_region
        }
      },
      # API Gateway メトリクス（4XX、5XXエラーのカウント）
      {
        "type"       = "metric",
        "x"          = 0,
        "y"          = 7,
        "width"      = 24,
        "height"     = 6,
        "properties" = {
          "metrics" = [
            [ "AWS/ApiGateway", "Count", "ApiName", var.api_gateway_name ],
            [ "AWS/ApiGateway", "5XXError", "ApiName", var.api_gateway_name ],
            [ "AWS/ApiGateway", "4XXError" "ApiName", var.api_gateway_name ]
          ],
          "view"        = "timeSeries",
          "stacked"     = false,
          "region"      = var.aws_region,
          "title"       = "API Gatewayメトリクス",
          "period"      = 300
        }
      }
    ]
  })
}