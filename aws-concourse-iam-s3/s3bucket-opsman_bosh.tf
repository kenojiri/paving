## inputs
## - environment_name

resource "aws_s3_bucket" "opsman" {
  bucket_prefix = "${var.environment_name}-opsman-"
}


data "aws_iam_policy_document" "opsman-s3" {
  statement {
    sid = "S3BucketPermissions"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.opsman.arn,
    ]
  }
  statement {
    sid = "S3ObjectPermissions"
    effect  = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectTagging",
    ]
    resources = [
      "${aws_s3_bucket.opsman.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "opsman-s3" {
  name   = "${var.environment_name}-opsman-s3-policy"
  policy = data.aws_iam_policy_document.opsman-s3.json
}

resource "aws_iam_role_policy_attachment" "opsman-s3" {
  role       = aws_iam_role.opsman.name
  policy_arn = aws_iam_policy.opsman-s3.arn
}

## outputs
## - opsman_bucket_name = aws_s3_bucket.opsman.bucket
