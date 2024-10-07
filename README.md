# セットアップ概要 Terraformの初期化や適用、削除の実行コマンド
前提:ローカル環境のディレクトリ内に用意した.tf形式のenvファイルが存在している
## Terraformの初期化（新規または既存の Terraform 構成を初期化する）
```
terraform init
```
## Terraform 構成の実行プランを作成する（Terraform が作成、変更、または削除するリソースを表示）
```
terraform plan
```
## Terraformを適用する（Terraform 構成を適用し、対象の環境でリソースを作成または変更する）
```
terraform apply
```
##  Terraformリソースを削除（プロジェクトが不要になったとき）
```
terraform destroy
```
## Terraform Workspaceを作成（異なる環境をわけて管理）
```
terraform new dev
terraform new stg
terraform new prod
```
## 各ワークスペースに適用される設定ファイルを分ける
```
# tfファイルを以下のようにリネームして各環境向けに変数を修正する
terraform.dev.tfvars
terraform.stg.tfvars
terraform.prod.tfvars
```
## exampleはサンプルなためリソース作成なしなためローカルに状態を保存
```
# vi backend.tf
terraform {
  backend "local" {
    path = "terraform.tfstate"  # ローカルに状態を保存
  }
}
```

## 各ワークスペースでの現在の状況を確認する
```
# ワークスペースを一覧表示
terraform workspace list

# dev環境
terraform workspace select dev
terraform plan -var-file="terraform.dev.tfvars"
# stg環境
terraform workspace select stg
terraform plan -var-file="terraform.stg.tfvars"
# prod環境
terraform workspace select prod
terraform plan -var-file="terraform.prod.tfvars"
```
## AWS上のリソース名を取得する
```
# DynamoDBテーブル名取得
# AWS CLI登録後に実行(my-aws-account-name)を適宜修正
aws dynamodb list-tables --profile my-aws-account-name --region ap-northeast-1

# API Gatewayの取得
aws apigateway get-rest-apis --profile my-aws-account-name --region ap-northeast-1

# Lambda関数の取得
aws apigateway get-rest-apis --profile my-aws-account-name --region ap-northeast-1
```


## terraform plan 実行時に「Backend initialization required」エラー表示時
```
# Terraformの初期化
terraform init -reconfigure
```
