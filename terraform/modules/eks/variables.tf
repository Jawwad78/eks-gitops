variable "aws_subnet_private" {
  type = list(string)
}

variable "aws_security_group_private" {
  type = string
}

variable "aws_iam_role_node" {
  type = string

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

variable "prometheusirsa" {
  type = string
}