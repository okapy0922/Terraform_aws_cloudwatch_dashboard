locals {
  # APIGatewayを参照、環境ごとのAPI名のパターンを定義
  api_names = {
    dev = {
      front_api    = "dev-front-api"
      auth_api     = "dev-auth-client-api"
      private_api  = "dev-private-api"
    }
    stg = {
      front_api   = "stg-front-api"
      auth_api    = "stg-auth-client-api"
    }
  }

  # 環境ごとのAPIリスト
  dev_api_list = [local.api_names.dev.front_api, local.api_names.dev.auth_api, local.api_names.dev.private_api]
  stg_api_list = [local.api_names.stg.front_api, local.api_names.stg.auth_api]

  # APIリストを文字列形式に変換
  dev_api_string = join(", ", local.dev_api_list)
  stg_api_string = join(", ", local.stg_api_list)

  # DynamoDBテーブル名を参照
  dynamodb_table_names = {
    dev = {
      user     = "dev_user_table"
      address  = "dev_address_table"
    }
    stg = {
      user     = "stg_user_table"
      address  = "stg_address_table"
    }
  }

  # 環境変数から現在の環境を取得
  current_env = var.env

  # 現在の環境のDynamoDBテーブルを配列形式で取得
  dynamodb_table_list = [
    local.dynamodb_table_names[local.current_env]["user"],
    local.dynamodb_table_names[local.current_env]["address"]
  ]

  # テーブル名のリストを文字列形式に変換
  table_name_string = join(", ", local.dynamodb_table_list)

  # DynamoDB メトリクス定義
  dynamodb_metrics = {
    "ConsumedReadCapacityUnits"     = { stat = "Average", name = "ConsumedReadCapacityUnits" }
    "ConsumedWriteCapacityUnits"    = { stat = "Average", name = "ConsumedWriteCapacityUnits" }
    "ProvisionedReadCapacityUnits"  = { stat = "Average", name = "ProvisionedReadCapacityUnits" }
    "ProvisionedWriteCapacityUnits" = { stat = "Average", name = "ProvisionedWriteCapacityUnits" }
    "ReturnedItemCount"             = { stat = "Sum",     name = "ReturnedItemCount" }
    "SuccessfulRequestLatency"      = { stat = "Average", name = "SuccessfulRequestLatency" }
    "Query"                         = { stat = "Average", name = "Query" }
    "UpdateItem"                    = { stat = "Average", name = "UpdateItem" }
    "PutItem"                       = { stat = "Average", name = "PutItem" }
    "GetItem"                       = { stat = "Average", name = "GetItem" }
    "SystemErrors"                  = { stat = "Sum",     name = "SystemErrors" }
  }

  # API Gateway メトリクス定義
  apigateway_metrics = {
    "APICallCount" = { stat = "Sum",  name = "APICallCount" }
    "4XXError"     = { stat = "Sum",  name = "4XXError" }
    "5XXError"     = { stat = "Sum",  name = "5XXError" }
    "Latency"      = { stat = "p99",  name = "Latency" }
  }
}