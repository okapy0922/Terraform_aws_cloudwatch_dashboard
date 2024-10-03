terraform {
  backend "s3" {
    bucket         = "dev-dashboad-terraform" # S3バケット名を指定
    key            = "path/to/my/statefile.tfstate" # S3バケットのオブジェクトキーを指定
    region         = "ap-northeast-1"
    profile        = var.profile
    encrypt        = true
  }
}