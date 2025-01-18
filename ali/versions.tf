terraform {
  required_version = "~> 1.10"

  required_providers {
    alicloud = {
      source  = "hashicorp/alicloud"
      version = "~> 1.0"
    }
  }
}