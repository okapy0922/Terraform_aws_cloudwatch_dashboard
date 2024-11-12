# 現在のAWSアカウントIDを取得
data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.project_name
  dashboard_body = jsonencode({
    widgets = [
      # マークダウン形式のメトリクス概要-DynamoDB
      {
        height = 2
        width  = 24
        y      = 0
        x      = 0
        type   = "text"
        properties = {
          markdown   = "# DynamoDB\n- ReadCapacityUnits\n- WriteCapacityUnits\n- ProvisionedReadCapacityUnits\n- ProvisionedWriteCapacityUnits\n- Return Count\n- SystemErrors"
          background = "transparent"
        }
      },
      # マークダウン形式のメトリクス概要-APIGateway
      {
        height = 2
        width  = 24
        y      = 17
        x      = 0
        type   = "text"
        properties = {
          markdown   = "# APIGateway\n- 総呼び出し数\n- 4XXError\n- 5XXError\n- 成功したリクエストレイテンシー"
          background = "transparent"
        }
      },
      # マークダウン形式のメトリクス概要-Lambda
      {
        height = 2
        width  = 24
        y      = 25
        x      = 0
        type   = "text"
        properties = {
          markdown   = "# Lambda\n- 実行時間\n- 実行回数"
          background = "transparent"
        }
      },
    # DynamoDB Readキャパシティユニットメトリクス
    {
    "height" = 8,
    "width"  = 12,
    "y"      = 2,
    "x"      = 0,
    "type"   = "metric",
      "properties" = {
        "view"    = "timeSeries",
        "stacked" = false,
        "metrics" = [
          for table_name in local.dynamodb_table_list : [
            "AWS/DynamoDB", local.dynamodb_metrics ["ConsumedReadCapacityUnits"]["name"], "TableName", table_name, { "stat" = local.dynamodb_metrics["ConsumedReadCapacityUnits"]["stat"] }
          ]
        ],
        "region" = var.aws_region,
        "title"  = "消費読み取りキャパシティユニット",
        "period" = 300,
        "yAxis" = {
          "left" = {
            "showUnits" = true
          }
        }
      }
    },
      # DynamoDB Writeキャパシティユニットメトリクス
      {
        "height" = 8,
        "width"  = 12,
        "y"      = 2,
        "x"      = 12,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            for table_name in local.dynamodb_table_list : [
              "AWS/DynamoDB", local.dynamodb_metrics ["ConsumedWriteCapacityUnits"]["name"], "TableName", table_name, { "stat" = local.dynamodb_metrics["ConsumedWriteCapacityUnits"]["stat"] }
            ]
          ],
          "region" = var.aws_region,
          "title"  = "消費書き込みキャパシティユニット",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true
              }
            }
        }
      },
      # DynamoDB ProvisionedReadキャパシティユニットメトリクス
      {
        "height" = 7,
        "width"  = 6,
        "y"      = 10,
        "x"      = 0,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            for table_name in local.dynamodb_table_list : [
              "AWS/DynamoDB", local.dynamodb_metrics ["ProvisionedReadCapacityUnits"]["name"], "TableName", table_name, { "stat" = local.dynamodb_metrics["ProvisionedReadCapacityUnits"]["stat"] }
            ]
          ],
          "region" = var.aws_region,
          "title"  = "プロビジョニング済み読み込みキャパシティユニット",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true
              }
            }
        }
      },
      # DynamoDB ProvisioneWriteキャパシティユニットメトリクス
      {
        "height" = 7,
        "width"  = 6,
        "y"      = 10,
        "x"      = 6,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            for table_name in local.dynamodb_table_list : [
              "AWS/DynamoDB", local.dynamodb_metrics ["ProvisionedWriteCapacityUnits"]["name"], "TableName", table_name, { "stat" = local.dynamodb_metrics["ProvisionedWriteCapacityUnits"]["stat"] }
            ]
          ],
          "region" = var.aws_region,
          "title"  = "プロビジョニング済み書き込みキャパシティユニット",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true
              }
            }
        }
      },
      # DynamoDB リターンアイテムカウント数
      {
        "height" = 7,
        "width"  = 6,
        "y"      = 10,
        "x"      = 12,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
              for table_name in local.dynamodb_table_list : [
                "AWS/DynamoDB", local.dynamodb_metrics ["ReturnedItemCount"]["name"], "TableName", table_name, { "stat" = local.dynamodb_metrics["ReturnedItemCount"]["stat"] } 
              ]
          ],
          "region" = var.aws_region,
          "title"  = "DynamoDB リターンカウント",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true
              }
            }
        }
      },
      # DynamoDB SystemErrors
      {
        "height" = 7,
        "width"  = 6,
        "y"      = 10,
        "x"      = 18,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
              for table_name in local.dynamodb_table_list : [
                "AWS/DynamoDB", local.dynamodb_metrics ["SystemErrors"]["name"], "TableName", table_name, { "stat" = local.dynamodb_metrics["SystemErrors"]["stat"] } 
              ]
          ],
          "region" = var.aws_region,
          "title"  = "DynamoDB SystemErrors",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true,
              "min" = 0 # Y軸の最小値が0に固定されるようにする（エラー数を0～カウント）
              }
            }
        }
      },
      # Lambda関数の実行時間
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 27,
        "x"      = 0,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            [ "AWS/Lambda", "Duration" ]
          ],
          "region" = var.aws_region,
          "title"  = "Lamnda関数 実行時間",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true
              }
            }
        }
      },
      # Lambda関数の実行回数
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 27,
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
              "showUnits" = true
              }
            }
        }
      },
      # APIGateway dev_API総呼び出し数
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 19,
        "x"      = 0,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            for api_name in local.dev_api_list : [
              "AWS/ApiGateway", local.APIGateway_metrics["APICallCount"]["name"], "ApiName", api_name, { "stat" = local.APIGateway_metrics["APICallCount"]["stat"] }
            ]
          ],
          "region" = var.aws_region,
          "title"  = "API総呼び出し数",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true
              }
            }
        }
      },
    # APIGateway dev_4xxエラー数
    {
        "height" = 6,
        "width"  = 6,
        "y"      = 19,
        "x"      = 6,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            for api_name in local.dev_api_list : [
              "AWS/ApiGateway", local.APIGateway_metrics["4XXError"]["name"], "ApiName", api_name, { "stat" = local.APIGateway_metrics["4XXError"]["stat"] }
            ]
          ],
          "region" = var.aws_region,
          "title"  = "4XXエラー数",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true,
              "min" = 0
              }
            }
        }
    },
      # APIGateway dev_5xxエラー数
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 19,
        "x"      = 12,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            for api_name in local.dev_api_list : [
              "AWS/ApiGateway", local.APIGateway_metrics["5XXError"]["name"], "ApiName", api_name, { "stat" = local.APIGateway_metrics["5XXError"]["stat"] }
            ]
          ],
          "region" = var.aws_region,
          "title"  = "5XXエラー数",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true,
              "min" = 0
              }
            },
        }
      },
      # APIGateway dev_成功したリクエストのレイテンシー
      {
        "height" = 6,
        "width"  = 6,
        "y"      = 19,
        "x"      = 18,
        "type"   = "metric",
        "properties" = {
          "view"    = "timeSeries",
          "stacked" = false,
          "metrics" = [
            for api_name in local.dev_api_list : [
              "AWS/ApiGateway", local.APIGateway_metrics["Latency"]["name"], "ApiName", api_name, { "stat" = local.APIGateway_metrics["Latency"]["stat"] }
            ]
          ],
          "region" = var.aws_region,
          "title"  = "SuccessfulRequestLatency",
          "period" = 300,
            "yAxis" = {
              "left" = {
              "showUnits" = true
              }
            },
        }
      },
    ]
  })
}