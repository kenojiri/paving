## inputs
## - environment_name

resource "aws_iam_role" "tas-cc" {
  name = "${var.environment_name}-tas-cc-role"

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

resource "aws_iam_instance_profile" "tas-cc" {
  name = "${var.environment_name}-tas-cc"
  role = aws_iam_role.tas-cc.name
  lifecycle {
    ignore_changes = [name]
  }
}

data "aws_iam_policy_document" "tas-cc" {
  statement {
    sid       = "InfoAboutCurrentInstanceProfile"
    effect    = "Allow"
    actions   = ["iam:GetInstanceProfile"]
    resources = [aws_iam_instance_profile.tas-cc.arn]
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

resource "aws_iam_policy" "tas-cc" {
  name   = "${var.environment_name}-tas-cc-role"
  policy = data.aws_iam_policy_document.tas-cc.json
}

resource "aws_iam_role_policy_attachment" "tas-cc" {
  role       = aws_iam_role.tas-cc.name
  policy_arn = aws_iam_policy.tas-cc.arn
}

## outputs
## - tas_cc_iam_instance_profile_name = aws_iam_instance_profile.tas-cc.name
