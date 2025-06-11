# セットアップ概要 Terraformの初期化や適用、削除の実行コマンド
前提:ローカル環境のディレクトリ内に用意した.tf形式のenvファイルが存在している

## バックエンドの初期化（新しいバックエンド構成をセットアップする、まずはinit）
```
terraform init
```

## Terraform Workspaceを作成（異なる環境をわけて管理）⇒用意したS3バケットなどに.tfstateファイルが保存されること
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
## Terraformの再初期化（再初期化、バックエンド構成を変更した際などに実行）
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
## エラー解決
```
Enter a value: yes

aws_cloudwatch_dashboard.dashboard: Creating...
╷
│ Error: putting CloudWatch Dashboard (Terraform-dashboad): operation error CloudWatch: PutDashboard, https response error StatusCode: 400, RequestID: 24736d90-0bb1-4b29-8447-96f7ee429b0a, InvalidParameterInput: The dashboard body is invalid, there are 6 validation errors:
│ [
│   {
│     "dataPath": "/widgets/4/properties/metrics/1/3",
│     "message": "Repeat marker \".\" used but not enough fields in previous metric"
│   },
│   {
│     "dataPath": "/widgets/6/properties/metrics/1/3",
│     "message": "Repeat marker \".\" used but not enough fields in previous metric"
│   {
│     "dataPath": "/widgets/9/properties/metrics/0",
│     "message": "Should NOT have more than 4 items"
│   }
│ ]
│
│   with aws_cloudwatch_dashboard.dashboard,
│   on main.tf line 20, in resource "aws_cloudwatch_dashboard" "dashboard":
│   20: resource "aws_cloudwatch_dashboard" "dashboard" {
│
╵
```
・ウィジェットの数え方は「０」ゼロから（0ベースインデックス）
 "dataPath": "/widgets/4/properties/metrics/1/3",
 
│"message": "Repeat marker \".\" used but not enough fields in previous metric"

ゼロから数えた４つ目のウィジェットで使用している"."の部分は必要なメトリクスが正しく設定されていないため修正が必要

・メトリクス内の配列で指定しているアイテムは最大４つまで
 
│"message": "Should NOT have more than 4 items"

## できあがったダッシュボード_v1
![image](https://github.com/user-attachments/assets/467893fb-8d61-4afa-a4d3-e7063597f2ea)




##  Terraformリソースを削除（プロジェクトが不要になったとき）
```
terraform destroy
```
