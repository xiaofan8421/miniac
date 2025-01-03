
variable "region" {
  description = "aws region"
  type        = string
  default     = "ap-east-1"
}

variable "zone" {
  description = "aws zone"
  type        = string
  default     = "ap-east-1a"
}

variable "ssh_key_path" {
  description = "the path of the ssh private key"
  type        = string
  default     = "~/.ssh/terraform/rsa"
}


variable "image" {
  description = "aws image"
  type        = string
  default     = "ami-0229eecc79425deae"
}

variable "ssh_user" {
  description = "aws image ssh default user"
  type        = string
  default     = "ubuntu"
}