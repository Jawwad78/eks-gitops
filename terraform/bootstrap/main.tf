module "s3" {
  source = "./modules/s3"

}

module "ecr" {
  source = "./modules/ecr"
}

module "route53" {
  source = "./modules/route53"
}