## inputs
## (none)

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "jumphost" {
  name = "jumphost-role"
  lifecycle {
    create_before_destroy = true
  }
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_instance_profile" "jumphost" {
  name = "jumphost"
  role = aws_iam_role.jumphost.name
  lifecycle {
    ignore_changes = [name]
  }
}

data "aws_iam_policy_document" "jumphost" {
  statement {
    sid       = "IAMPermissions"
    effect    = "Allow"
    actions   = [
      "iam:GetRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PassRole",

      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:CreatePolicy",
      "iam:DeletePolicy",

      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",

      "iam:GetInstanceProfile",
      "iam:ListInstanceProfilesForRole",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EC2Permissions"
    effect = "Allow"
    actions = [
      "ec2:DescribeRegions",
      "ec2:DescribeAvailabilityZones",

      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcClassicLink",
      "ec2:DescribeVpcClassicLinkDnsSupport",

      "ec2:CreateVpc",
      "ec2:DeleteVpc",
      "ec2:ModifyVpcAttribute",

      "ec2:DescribeNatGateways",
      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway",

      "ec2:DescribeInternetGateways",
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",

      "ec2:DescribeTransitGateways",
      "ec2:CreateTransitGateway",
      "ec2:DeleteTransitGateway",
      "ec2:ModifyTransitGateway",

      "ec2:DescribeTransitGatewayVpcAttachments",
      "ec2:CreateTransitGatewayVpcAttachment",
      "ec2:DeleteTransitGatewayVpcAttachment",

      "ec2:DescribeSubnets",
      "ec2:DescribePrefixLists",
      "ec2:CreateSubnet",
      "ec2:DeleteSubnet",

      "ec2:DescribeSecurityGroups",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",

      "ec2:DescribeNetworkInterfaces",

      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:ReleaseAddress",
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",

      "ec2:DescribeRouteTables",
      "ec2:GetTransitGatewayRouteTableAssociations",
      "ec2:GetTransitGatewayRouteTablePropagations",
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",

      "ec2:CreateRoute",
      "ec2:DeleteRoute",

      "ec2:DescribeTags",
      "ec2:CreateTags",
      "ec2:DeleteTags",

      "ec2:DescribeVpcEndpoints",
      "ec2:CreateVpcEndpoint",
      "ec2:DeleteVpcEndpoints",

      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DeleteListener",

      "ec2:DescribeKeypairs",
      "ec2:ImportKeyPair",
      "ec2:DeleteKeyPair",

      "ec2:DescribeAccountAttributes",
      "ec2:DescribeImages",
      "ec2:DeregisterImage",

      "ec2:DescribeInstances",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:RebootInstances",

      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",

      "ec2:DescribeVolumes",
      "ec2:CreateVolume",
      "ec2:DeleteVolume",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",

      "ec2:DescribeSnapshots",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
    ]
    resources = ["*"]
  }

  statement {
    sid     = "Route53Permissions"
    effect  = "Allow"
    actions = [
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:CreateHostedZone",
      "route53:DeleteHostedZone",
      "route53:GetChange",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
      "route53:ListTagsForResource",
    ]
    resources = ["*"]
  }

  statement {
    sid     = "S3Permissions"
    effect  = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl",
      "s3:GetBucketCors",
      "s3:GetBucketWebsite",
      "s3:GetBucketVersioning",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketLogging",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketTagging",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:PutBucketVersioning",
      "s3:PutBucketTagging",
    ]
    resources = ["*"]
  }

  statement {
    sid     = "RDSPermissions"
    effect  = "Allow"
    actions = [
      "rds:DescribeDBInstances",
      "rds:CreateDBInstance",
      "rds:DeleteDBInstance",
      "rds:ModifyDBInstance",
      "rds:DescribeDBSubnetGroups",
      "rds:CreateDBSubnetGroup",
      "rds:DeleteDBSubnetGroup",
      "rds:ListTagsForResource",
      "rds:AddTagsToResource",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ASMPermissions"
    effect = "Allow"
    actions = [
      "secretsmanager:*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ACMPermissions"
    effect = "Allow"
    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",
      "acm:ImportCertificate",
      "acm:DeleteCertificate",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "jumphost" {
  name   = "jumphost"
  policy = data.aws_iam_policy_document.jumphost.json
}

resource "aws_iam_role_policy_attachment" "jumphost" {
  role       = aws_iam_role.jumphost.name
  policy_arn = aws_iam_policy.jumphost.arn
}

## outputs
## - iam_instance_profile_name = aws_iam_instance_profile.jumphost.name
