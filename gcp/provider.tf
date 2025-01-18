
provider "google" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket       = "roy-tf-dev"
    key          = "terraform/gcp/state"
    region       = "ap-east-1"
    use_lockfile = true
  }
}