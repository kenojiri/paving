## inputs
## - environment_name

resource "aws_iam_role" "opsman" {
  name = "${var.environment_name}-opsman-role"

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

resource "aws_iam_instance_profile" "opsman" {
  name = "${var.environment_name}-opsman"
  role = aws_iam_role.opsman.name
  lifecycle {
    ignore_changes = [name]
  }
}

data "aws_iam_policy_document" "opsman" {
  statement {
    sid       = "InfoAboutCurrentInstanceProfile"
    effect    = "Allow"
    actions   = ["iam:GetInstanceProfile"]
    resources = [aws_iam_instance_profile.opsman.arn]
  }

  statement {
    sid     = "CreateInstanceWithCurrentInstanceProfile"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = compact([
      aws_iam_role.opsman.arn,
    ])
  }

  statement {
    sid    = "EC2Permissions"
    effect = "Allow"
    actions = [
      "ec2:DescribeKeypairs",
      "ec2:DescribeVpcs",
      "ec2:DescribeSecurityGroups",
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
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroups",
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
    sid     = "S3Permissions"
    effect  = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:*Object",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "opsman" {
  name   = "${var.environment_name}-opsman-role"
  policy = data.aws_iam_policy_document.opsman.json
}

resource "aws_iam_role_policy_attachment" "opsman" {
  role       = aws_iam_role.opsman.name
  policy_arn = aws_iam_policy.opsman.arn
}

## outputs
## - opsman_iam_instance_profile_name = aws_iam_instance_profile.opsman.name
