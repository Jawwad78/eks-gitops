output "node_group_name" {
  value = aws_eks_node_group.example.arn
}

output "aws_eks_addon" {
  value = aws_eks_addon.ebs_csi_driver.arn
}