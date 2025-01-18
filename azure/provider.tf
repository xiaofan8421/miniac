
provider "azurerm" {
  features {}
}

terraform {
  backend "s3" {
    bucket       = "roy-tf-dev"
    key          = "terraform/azure/state"
    region       = "ap-east-1"
    use_lockfile = true
  }
}