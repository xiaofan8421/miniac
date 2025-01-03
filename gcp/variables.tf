
variable "region" {
  description = "gcp region"
  type        = string
  default     = "asia-east2"
}

variable "zone" {
  description = "gcp zone"
  type        = string
  default     = "asia-east2-b"
}

variable "ssh_key_path" {
  description = "the path of the ssh private key"
  type        = string
  default     = "~/.ssh/terraform/rsa"
}

variable "image" {
  description = "gcp image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}