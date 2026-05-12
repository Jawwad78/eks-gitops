resource "aws_route53_zone" "example" {
  name = "jawwad.org"

  tags = {
    name = "Route53"
  }
}