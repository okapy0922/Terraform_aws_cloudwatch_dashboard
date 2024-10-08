# セットアップ概要 Terraformの初期化や適用、削除の実行コマンド
前提:ローカル環境のディレクトリ内に用意した.tf形式のenvファイルが存在している
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
## AWSのプロファイルを指定する
```
# 用意したプロファイル名を確認する
aws configure list-profiles

# 指定したプロファイルで作業する
aws sts get-caller-identity --profile プロファイル名
```
## Terraformの初期化
```
terraform init -reconfigure
```

## 現状の実行計画を確認する「terraform planコマンド」
```
terraform plan
```
## Terraformを適用する（Terraform 構成を適用し、対象の環境でリソースを作成または変更する）
```
terraform apply

# .tfverファイルを指定してインフラストラクチャをデプロイする例
terraform apply -var-file="terraform.環境名.tfvars"

# 「Enter a value:」をyesで進む

```
##  Terraformリソースを削除（プロジェクトが不要になったとき）
```
terraform destroy
```
