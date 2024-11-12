terraform {
  backend "s3" {
    bucket         = "dev-glico-sunao-cw-dashboad-terraform-state" # S3バケット名を指定
    region         = "ap-northeast-1"  # リージョンを指定
    profile        ="LogMon-Admin" # 使用するプロファイル（AWSアカウント名）を指定
    encrypt        = true
    key            = "terraform/state/terraform.tfstate"  # stateファイルを保管するS3内ファイルパスを指定
  }
}