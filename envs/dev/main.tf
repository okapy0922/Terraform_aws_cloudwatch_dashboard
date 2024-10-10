# 現在のAWSアカウントIDを取得
data "aws_caller_identity" "current" {}

locals {
  # DynamoDB メトリクス定義
  dynamodb_metrics = {
    "ConsumedReadCapacityUnits"     = { "stat" = "Average", "name" = "ConsumedReadCapacityUnits" },
    "ConsumedWriteCapacityUnits"    = { "stat" = "Average", "name" = "ConsumedWriteCapacityUnits" },
    "ProvisionedReadCapacityUnits"  = { "stat" = "Average", "name" = "ProvisionedReadCapacityUnits" },
    "ProvisionedWriteCapacityUnits" = { "stat" = "Average", "name" = "ProvisionedWriteCapacityUnits" },
    "ReturnedItemCount"             = { "stat" = "Sum", "name" = "ReturnedItemCount" },
    "SuccessfulRequestLatency"      = { "stat" = "Average", "name" = "SuccessfulRequestLatency" },
    "Query"                         = { "stat" = "Average", "name" = "Query" },
    "UpdateItem"                    = { "stat" = "Average", "name" = "UpdateItem" },
    "PutItem"                       = { "stat" = "Average", "name" = "PutItem" },
    "GetItem"                       = { "stat" = "Average", "name" = "GetItem" }
  }

  # API Gateway メトリクス定義
  APIGateway_metrics = {
    "APICallCount" = { "stat" = "Sum", "name" = "APICallCount" },
    "4XXError"     = { "stat" = "Sum", "name" = "4XXError" },
    "5XXError"     = { "stat" = "Sum", "name" = "5XXError" },
    "Latency"      = { "stat" = "Average", "name" = "Latency" }
  }
}

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.project_name
  dashboard_body = jsonencode({
    widgets = [
      # マークダウン形式のメトリクス概要-DynamoDB
      {
        height = 3
        width  = 24
        y      = 0
        x      = 0
        type   = "text"
        properties = {
          markdown   = "# DynamoDB\n- 消費Capacity Unit\n- Return Count\n- Latency\n"
          background = "transparent"
        }
      },
      # マークダウン形式のメトリクス概要-Lambda
      {
        height = 2
        width  = 24
        y      = 9
        x      = 0
        type   = "text"
        properties = {
          markdown   = "# Lambda\n- 実行時間\n- 実行回数"
          background = "transparent"
        }
      },
      # マークダウン形式のメトリクス概要-APIGateway
      {
        height = 1
        width  = 24
        y      = 18
        x      = 0
        type   = "text"
        properties = {
          markdown   = "# APIGateway\n- 5XXError\n- 4XXError"
          background = "transparent"
        }
      },
      # DynamoDB キャパシティユニットメトリクス
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
            [ "AWS/DynamoDB", local.dynamodb_metrics["ConsumedReadCapacityUnits"]["name"], "TableName", var.dynamodb_table_name ],
            [ "AWS/DynamoDB", local.dynamodb_metrics["ConsumedWriteCapacityUnits"]["name"], "TableName", var.dynamodb_table_name ],
            [ "AWS/DynamoDB", local.dynamodb_metrics["ProvisionedReadCapacityUnits"]["name"], "TableName", var.dynamodb_table_name ],
            [ "AWS/DynamoDB", local.dynamodb_metrics["ProvisionedWriteCapacityUnits"]["name"], "TableName", var.dynamodb_table_name ]
          ],
          "region" = var.aws_region,
          "title"  = "DynamoDB キャパシティユニット",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "label" = "各種ユニット",
              "showUnits" = true
              }
            }
        }
      },
      # DynamoDB リターンアイテムカウント数
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
            [ "AWS/DynamoDB", local.dynamodb_metrics["ReturnedItemCount"]["name"], "TableName", var.dynamodb_table_name ]
          ],
          "region" = var.aws_region,
          "title"  = "DynamoDB Return Count",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "label" = "Count",
              "showUnits" = true
              }
            }
        }
      },
      # DynamoDB 成功したリクエストのレイテンシー
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
            [ "AWS/DynamoDB", local.dynamodb_metrics["Query"]["name"], { "stat" = local.dynamodb_metrics["Query"]["stat"] } ],
            [ "AWS/DynamoDB", local.dynamodb_metrics["UpdateItem"]["name"], { "stat" = local.dynamodb_metrics["UpdateItem"]["stat"] } ],
            [ "AWS/DynamoDB", local.dynamodb_metrics["PutItem"]["name"], { "stat" = local.dynamodb_metrics["PutItem"]["stat"] } ],
            [ "AWS/DynamoDB", local.dynamodb_metrics["GetItem"]["name"], { "stat" = local.dynamodb_metrics["GetItem"]["stat"] } ]
          ],
          "region" = var.aws_region,
          "title"  = "SuccessfulRequestLatency",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "label" = "ミリ秒単位",
              "showUnits" = true
              }
            }
        }
      },
      # Lambda関数の実行時間および実行回数
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
            [ "AWS/Lambda", "Duration" ]
          ],
          "region" = var.aws_region,
          "title"  = "Lamnda関数 所要時間",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "label" = "ミリ秒単位",
              "showUnits" = true
              }
            }
        }
      },
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
          "region" = var.aws_region,
          "title"  = "Lamnda関数 実行回数",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "label" = "Count",
              "showUnits" = true
              }
            }
        }
      },
      # APIGateway クライアント・サーバエラー
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 20,
        "x"      = 0,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            [ "AWS/ApiGateway", local.APIGateway_metrics["APICallCount"]["name"], { "stat" = local.APIGateway_metrics["APICallCount"]["stat"] } ],
            [ "AWS/ApiGateway", local.APIGateway_metrics["5XXError"]["name"], { "stat" = local.APIGateway_metrics["5XXError"]["stat"] } ],
            [ "AWS/ApiGateway", local.APIGateway_metrics["4XXError"]["name"], { "stat" = local.APIGateway_metrics["4XXError"]["stat"] } ]
          ],
          "region" = var.aws_region,
          "title"  = "5XX/4XX Error",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "label" = "Count",
              "showUnits" = true
              }
            }
        }
      }
    ]
  })
}