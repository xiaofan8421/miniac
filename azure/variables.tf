
variable "region" {
  description = "azure location"
  type        = string
  default     = "East Asia"
}

variable "ssh_key_path" {
  description = "the path of the ssh private key"
  type        = string
  default     = "~/.ssh/terraform/rsa"
}


variable "publisher" {
  description = "azure image publisher"
  type        = string
  default     = "Canonical"
}

variable "offer" {
  description = "azure image offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "sku" {
  description = "azure image sku"
  type        = string
  default     = "22_04-lts-gen2"
}