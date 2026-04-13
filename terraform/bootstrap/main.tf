module "s3" {
  source = "./modules/s3"

}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "ecr" {
  source = "./modules/ecr"
}

module "route53" {
  source = "./modules/route53"
}