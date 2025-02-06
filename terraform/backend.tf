terraform {
  backend "s3" {
    bucket = "3tier-backend-state-bucket"
    key    = "state-file-folder"
    region = "us-west-2"
    # dynamodb_table = "terraform-state-lock"
  }
}