variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}