module "vpc" {
  source     = "./modules/vpc"
  http_port  = var.http_port
  https_port = var.https_port

}

module "eks" {
  source                     = "./modules/eks"
  aws_subnet_private         = module.vpc.aws_subnet_private
  aws_security_group_private = module.vpc.aws_security_group_private
  aws_iam_role_node          = module.iam.aws_iam_role_node
  principal_arn              = var.principal_arn
  desired_size               = var.desired_size
  min_size                   = var.min_size
  max_size                   = var.max_size
  max_unavailable            = var.max_unavailable
  authentication_mode        = var.authentication_mode
}

module "iam" {
  source = "./modules/iam"

}
module "kubernetes" {
  source = "./modules/kubernetes"
}