## inputs
## (none)

resource "aws_iam_role" "jumphost" {
  name = "jumphost-role"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
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
      "iam:GetInstanceProfile",
      "iam:PassRole",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EC2Permissions"
    effect = "Allow"
    actions = [
      "ec2:CreateVpc",
      "ec2:CreateTransitGateway",
      "ec2:CreateTags",
      "ec2:DescribeVpcs",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpcAttribute",
      "ec2:DeleteVpc",
      "ec2:DeleteTransitGateway",
      "ec2:ModifyVpcAttribute",
      "ec2:CreateSubnet",
      "ec2:CreateSecurityGroup",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteSubnet",
      "ec2:DeleteSecurityGroup",
      "ec2:CreateTransitGatewayVpcAttachment",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DescribeTransitGatewayVpcAttachments",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:GetTransitGatewayRouteTableAssociations",
      "ec2:GetTransitGatewayRouteTablePropagations",
      "ec2:DeleteTransitGatewayVpcAttachment",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:CreateVpcEndpoint",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribePrefixLists",
      "ec2:DeleteVpcEndpoints",
      "ec2:ModifyTransitGateway",
      "ec2:DescribeTags",
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
    sid     = "Route53Permissions"
    effect  = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:GetHostedZone",
      "route53:ListTagsForResource",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:ListResourceRecordSets",
    ]
    resources = ["*"]
  }

  statement {
    sid     = "S3Permissions"
    effect  = "Allow"
    actions = [
      "s3:CreateBucket",
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
      "s3:DeleteBucket",
      "s3:PutBucketVersioning",
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
