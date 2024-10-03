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
