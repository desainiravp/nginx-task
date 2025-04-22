variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Your EC2 key pair name in AWS"
  type        = string
}

variable "private_key_path" {
  description = "Path to your .pem private key file"
  type        = string
}

variable "ssh_user" {
  default = "ubuntu"
}
