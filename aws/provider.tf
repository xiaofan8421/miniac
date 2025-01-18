
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Product     = "single-node"
      Environment = "dev"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "roy-tf-dev"
    key    = "terraform/state"
    region = "ap-east-1"
  }
}
