## inputs
## - paving_pfmgmt_allowed_iam_user_arns

data "aws_iam_policy_document" "assume-role-policy" {
  # allow IAM users to assume this role
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = var.paving_pfmgmt_allowed_iam_user_arns
      #identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "paving-pfmgmt" {
  provider = aws.sandbox_account
  name = "paving-pfmgmt-role"
  lifecycle {
    create_before_destroy = true
  }
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

data "aws_iam_policy_document" "paving-pfmgmt" {
  statement {
    sid       = "GetInfoAboutCurrentInstanceProfile"
    effect    = "Allow"
    actions   = [
      "iam:GetInstanceProfile",
    ]
    resources = [aws_iam_instance_profile.opsman.arn]
  }

  statement {
    sid       = "CreateOpsManInstanceWithInstanceProfile"
    effect    = "Allow"
    actions   = [
      "iam:PassRole",
    ]
    resources = compact([
      aws_iam_role.opsman.arn,
    ])
  }

  statement {
    sid       = "IAMPermissions"
    effect    = "Allow"
    actions   = [
      "iam:CreateServiceLinkedRole",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EC2Permissions"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpcAttribute",
      "ec2:CreateSubnet",
      "ec2:CreateSecurityGroup",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteSubnet",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DescribeTransitGatewayVpcAttachments",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:GetTransitGatewayRouteTableAssociations",
      "ec2:GetTransitGatewayRouteTablePropagations",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribePrefixLists",
      "ec2:DescribeTags",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeInstanceTypes",
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
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeImages",
      "ec2:DeregisterImage",
      "ec2:DescribeSubnets",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:DescribeInstances",
      "ec2:TerminateInstances",
      "ec2:RebootInstances",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "ec2:DescribeAddresses",
      "ec2:DisassociateAddress",
      "ec2:AssociateAddress",
      "ec2:CreateTags",
      "ec2:DescribeVolumes",
      "ec2:CreateVolume",
      "ec2:AttachVolume",
      "ec2:DeleteVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:DescribeRegions",
    ]
    resources = ["*"]
  }

  statement {
    sid     = "RDSPermissions"
    effect  = "Allow"
    actions = [
      "rds:CreateDBSubnetGroup",
      "rds:AddTagsToResource",
      "rds:DescribeDBSubnetGroups",
      "rds:ListTagsForResource",
      "rds:DeleteDBSubnetGroup",
      "rds:CreateDBInstance",
      "rds:DescribeDBInstances",
      "rds:DeleteDBInstance",
      "rds:ModifyDBInstance",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "paving-pfmgmt" {
  provider = aws.sandbox_account
  name   = "paving-pfmgmt"
  policy = data.aws_iam_policy_document.paving-pfmgmt.json
}

resource "aws_iam_role_policy_attachment" "paving-pfmgmt" {
  provider = aws.sandbox_account
  role       = aws_iam_role.paving-pfmgmt.name
  policy_arn = aws_iam_policy.paving-pfmgmt.arn
}

## outputs
## - paving_pfmgmt_role_arn = aws_iam_role.paving-pfmgmt.arn
