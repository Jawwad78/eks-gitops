variable "region" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "principal_arn" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "max_unavailable" {
  type = number
}

variable "authentication_mode" {
  type = string
}

