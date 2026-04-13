resource "aws_iam_openid_connect_provider" "default" {
  url = "https://oidc.eks.eu-west-2.amazonaws.com/id/0EADC56E821A14418E735507C917C1F9"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}