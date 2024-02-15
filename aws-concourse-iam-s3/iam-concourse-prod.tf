## inputs
## - environment_name

resource "aws_iam_role" "concourse_prod" {
  provider = aws.prod_account
  name = "${var.environment_name}-concourse-prod-role"
  lifecycle {
    create_before_destroy = true
  }
  assume_role_policy = data.aws_iam_policy_document.concourse_assume_role_policy.json
}

resource "aws_iam_policy" "concourse_prod" {
  provider = aws.prod_account
  name   = "${var.environment_name}-concourse-prod-role"
  policy = data.aws_iam_policy_document.concourse.json
}

resource "aws_iam_role_policy_attachment" "concourse_prod" {
  provider = aws.prod_account
  role       = aws_iam_role.concourse_prod.name
  policy_arn = aws_iam_policy.concourse_prod.arn
}

## outputs
## - concourse_prod_iam_role_arn = aws_iam_role.concourse_prod.arn
