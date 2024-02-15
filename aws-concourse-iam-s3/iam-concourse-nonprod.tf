## inputs
## - environment_name

resource "aws_iam_role" "concourse_nonprod" {
  provider = aws.nonprod_account
  name = "${var.environment_name}-concourse-nonprod-role"
  lifecycle {
    create_before_destroy = true
  }
  assume_role_policy = data.aws_iam_policy_document.concourse_assume_role_policy.json
}

resource "aws_iam_policy" "concourse_nonprod" {
  provider = aws.nonprod_account
  name   = "${var.environment_name}-concourse-nonprod-role"
  policy = data.aws_iam_policy_document.concourse.json
}

resource "aws_iam_role_policy_attachment" "concourse_nonprod" {
  provider = aws.nonprod_account
  role       = aws_iam_role.concourse_nonprod.name
  policy_arn = aws_iam_policy.concourse_nonprod.arn
}

## outputs
## - concourse_nonprod_iam_role_arn = aws_iam_role.concourse_nonprod.arn
