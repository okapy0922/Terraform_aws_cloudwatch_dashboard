locals {
  # APIGatewayを参照、環境ごとのAPI名のパターンを定義
  api_names = {
    dev = {
      front_api = "dev-glico-sunao-api"
      auth_api  = "dev-glico-sunao-auth-client"
      private_api = "dev-sunao-bgl-recording-api"
    }
    stg = {
      front_api = "stg-glico-sunao-api"
      auth_api  = "stg-glico-sunao-auth-client"
    }
  }
}

locals{
    # dev環境のAPIリスト
    dev_api_list = [local.api_names.dev.front_api, local.api_names.dev.auth_api, local.api_names.dev.private_api]
}
locals{
    # dev環境のAPIリストを文字列形式に変換
    dev_api_string = join(", ", local.dev_api_list)
}
locals{
    # stg環境のAPIリスト
    stg_api_list = [local.api_names.stg.front_api, local.api_names.stg.auth_api]
}
locals{
    # stg環境のAPIリストを文字列形式に変換
    stg_api_string = join(", ", local.stg_api_list)
}

locals{
    # DynamoDBテーブル名を参照
    dynamodb_table_names = { # DynamoDBテーブルリスト
      ages  = "dev_sunao_bgl_recording_ages_table"
      bgl   = "dev_sunao_bgl_recording_bgl_table"
      hb1c  = "dev_sunao_bgl_recording_hb1c_table"
      user  = "dev_sunao_bgl_recording_user_table"
    }
}
locals{
  # DynamoDBテーブルを配列形式で取得
  dynamodb_table_list = [
    local.dynamodb_table_names["ages"],
    local.dynamodb_table_names["bgl"],
    local.dynamodb_table_names["hb1c"],
    local.dynamodb_table_names["user"]
    ]
}
locals{
  # テーブル名のリストを文字列形式に変換
  tamble_name_string = join(", ", local.dynamodb_table_list)
}

locals{
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
    "GetItem"                       = { "stat" = "Average", "name" = "GetItem" },
    "SystemErrors"                  = { "stat" = "Sum", "name" = "SystemErrors" }
  }

  # API Gateway メトリクス定義
  APIGateway_metrics = {
    "APICallCount" = { "stat" = "Sum", "name" = "APICallCount" },
    "4XXError"     = { "stat" = "Sum", "name" = "4XXError" },
    "5XXError"     = { "stat" = "Sum", "name" = "5XXError" },
    "Latency"      = { "stat" = "p99", "name" = "Latency" }
  }
}