
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
    bucket       = "roy-tf-dev"
    key          = "terraform/aws/state"
    region       = "ap-east-1"
    use_lockfile = true
  }
}
