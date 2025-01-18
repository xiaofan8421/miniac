
provider "alicloud" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket       = "roy-tf-dev"
    key          = "terraform/ali/state"
    region       = "ap-east-1"
    use_lockfile = true
  }
}