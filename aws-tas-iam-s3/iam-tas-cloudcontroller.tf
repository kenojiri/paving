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

## outputs
## - tas_cc_iam_instance_profile_name = aws_iam_instance_profile.tas-cc.name
