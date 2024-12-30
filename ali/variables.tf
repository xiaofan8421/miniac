
variable "region" {
  description = "ali region"
  type        = string
  default     = "cn-hangzhou"
}

variable "zone" {
  description = "ali zone"
  type        = string
  default     = "cn-hangzhou-i"
}

variable "ssh_key_path" {
  description = "the path of the ssh private key"
  type        = string
  default     = "~/.ssh/terraform/rsa"
}

variable "image" {
  description = "ali image"
  type        = string
  default     = "ubuntu_22_04_x64_20G_alibase_20240130.vhd"
}