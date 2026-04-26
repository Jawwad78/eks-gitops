resource "aws_iam_policy" "policy_for_svcaccount" {
  name = "dns_manager"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "route53:GetChange",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones"
        ],
        "Resource" : "arn:aws:route53:::hostedzone/Z02961562YZEMBNSY5HGH", # You can change this to YOUR specific hosted zone,
        "Condition": {
        "ForAllValues:StringLike": {
          "route53:ChangeResourceRecordSetsActions": ["CREATE", "UPSERT", "DELETE"],
          "route53:ChangeResourceRecordSetsRecordTypes": ["TXT"]
        }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ListHostedZonesByName",
        "Resource" : "*"
      },
    ]
  })
}

resource "aws_iam_role" "irsa" {
  name = "irsa"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::726661503364:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5"
        },
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5:sub" : "system:serviceaccount:cert-manager:cert-manager"
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

resource "aws_iam_policy" "policy_for_external_dns" {
  name = "external_dns_policy"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource" : [ "arn:aws:route53:::hostedzone/Z02961562YZEMBNSY5HGH", # You can change this to YOUR specific hosted zone,
      ]
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResource",
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
 })
}

resource "aws_iam_role" "external-dns" {
  name = "external-dns"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::726661503364:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5"
        },
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5:sub" : "system:serviceaccount:default:external-dns"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "externaldns-attacth" {
  role       = aws_iam_role.external-dns.name
  policy_arn = aws_iam_policy.policy_for_external_dns.arn
} 

# Creating irsa for prometheus=  ebs storage
resource "aws_iam_role" "prometheusirsa" {
  name = "prometheusirsa"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::726661503364:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5"
        },
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5:aud": "sts.amazonaws.com",
                    "oidc.eks.eu-west-2.amazonaws.com/id/4197F45D6D65EC166B272BDC4FF9B6F5:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}


# The add on role needs an IAM policy for ec2 otherwise it will be in a pending state waiting
# for pods to become active
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.prometheusirsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}