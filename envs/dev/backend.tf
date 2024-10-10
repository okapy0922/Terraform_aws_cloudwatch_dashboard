terraform {
  backend "s3" {
    bucket         = "cloudwatch-dashboad-terraform-dev" # S3バケット名を指定
    region         = "ap-northeast-1"  # リージョンを指定
    profile        ="okada-trail-setup" # 使用するプロファイル（AWSアカウント名）を指定
    encrypt        = true
    key            = "terraform/state/terraform.tfstate"  # stateファイルを保管するS3内ファイルパスを指定
  }
}