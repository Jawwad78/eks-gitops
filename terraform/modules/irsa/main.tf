resource "aws_iam_policy" "policy_for_svcaccount" {
  name        = "dns_manager"

  policy = jsonencode({
    "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/Z02961562YZEMBNSY5HGH", # You can change this to YOUR specific hosted zone,
      "Condition": {                                                    
        "ForAllValues:StringEquals": {
          "route53:ChangeResourceRecordSetsRecordTypes": ["TXT"]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
      },
    ]
  })
}

resource "aws_iam_role" "irsa" {
  name = "irsa"

  assume_role_policy = jsonencode({
      "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": {
        "Federated": "arn:aws:iam::726661503364:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5"
      },
      "Condition": {
        "StringEquals": {
           "oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5:sub": "system:serviceaccount:cert-manager:cert-manager"
        }
      }
    }
  ]
 })
}

resource "aws_iam_role_policy_attachment" "irsa-attacth" {
  role       = aws_iam_role.irsa.name
  policy_arn = aws_iam_policy.policy_for_svcaccount.arn
}