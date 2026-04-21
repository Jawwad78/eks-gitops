resource "aws_iam_openid_connect_provider" "default" {
  url = "https://oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}