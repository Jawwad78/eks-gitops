output "aws_subnet_private" {
  value = aws_subnet.private[*].id
}

output "aws_security_group_private" {
  value = aws_security_group.private-sg.id
}
