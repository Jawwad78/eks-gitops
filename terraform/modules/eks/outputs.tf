output "node_group_name" {
  value = aws_eks_node_group.example.arn
}

output "aws_eks_addon" {
  value = aws_eks_addon.ebs_csi_driver.arn
}

output "aws_eks_cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "aws_eks_cluster_certificate_authority" {
  value = aws_eks_cluster.example.certificate_authority.0.data
}

output "aws_eks_cluster_name" {
  value = aws_eks_cluster.example.name
}