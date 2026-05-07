resource "aws_eks_cluster" "example" {
  name = "eks-cluster"

  access_config {
    authentication_mode = var.authentication_mode
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.35"

  vpc_config {
    subnet_ids         = var.aws_subnet_private
    security_group_ids = [var.aws_security_group_private]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

#create access entry so I can acces the cluster from laptop
resource "aws_eks_access_entry" "example" {
  cluster_name      = aws_eks_cluster.example.name
  principal_arn     = var.principal_arn
  kubernetes_groups = ["group-1"]
  type              = "STANDARD"
}

#add view policy to access entry to view pods,svs etc
resource "aws_eks_access_policy_association" "example" {
  cluster_name  = aws_eks_cluster.example.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = var.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "example2" {
  cluster_name  = aws_eks_cluster.example.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.principal_arn

  access_scope {
    type = "cluster"
  }
}


#create nodes
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example"
  node_role_arn   = var.aws_iam_role_node
  subnet_ids      = var.aws_subnet_private

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  #how many nodes can be updated at the same time
  update_config {
    max_unavailable = var.max_unavailable
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [var.aws_iam_role_node]

}


resource "aws_iam_openid_connect_provider" "cluster" {
  url = aws_eks_cluster.example.identity.0.oidc.0.issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

# adding acees entry for my oidc with github to connect to cluster
resource "aws_eks_access_entry" "oidceks_entry" {
  cluster_name      = aws_eks_cluster.example.name
  principal_arn     = var.oidc_principle_arn
  kubernetes_groups = ["group-2"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "oidc_access_entry_policy" {
  cluster_name  = aws_eks_cluster.example.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.oidc_principle_arn

  access_scope {
    type = "cluster"
  }
}


# Creating add on ebs storage for prometheus
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.example.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.58.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = var.prometheusirsa

  depends_on = [aws_eks_node_group.example]

}