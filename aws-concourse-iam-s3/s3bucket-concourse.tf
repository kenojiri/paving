## inputs
## - environment_name

resource "aws_s3_bucket" "pipeline" {
  provider = aws.sandbox_account
  bucket_prefix = "${var.environment_name}-pipeline-"
}

resource "aws_kms_key" "pipeline" {
  provider = aws.sandbox_account
  description = "This key is used to encrypt objects in pipeline bucket"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "pipeline-alias" {
  provider = aws.sandbox_account
  name = "alias/${var.environment_name}-pipeline"
  target_key_id = aws_kms_key.pipeline.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline" {
  provider = aws.sandbox_account
  bucket = aws_s3_bucket.pipeline.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.pipeline.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket" "backup" {
  provider = aws.sandbox_account
  bucket_prefix = "${var.environment_name}-backup-"
}

resource "aws_kms_key" "backup" {
  provider = aws.sandbox_account
  description = "This key is used to encrypt objects in backup bucket"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "backup-alias" {
  provider = aws.sandbox_account
  name = "alias/${var.environment_name}-backup"
  target_key_id = aws_kms_key.backup.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  provider = aws.sandbox_account
  bucket = aws_s3_bucket.backup.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backup.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


data "aws_iam_policy_document" "concourse-s3" {
  # see https://github.com/concourse/s3-resource?tab=readme-ov-file#required-iam-permissions
  statement {
    sid = "S3BucketPermissions"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.pipeline.arn,
      aws_s3_bucket.backup.arn,
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
      "${aws_s3_bucket.pipeline.arn}/*",
      "${aws_s3_bucket.backup.arn}/*",
    ]
  }
  statement {
    sid     = "RequiredIfUsingCustomKMSKeys"
    effect  = "Allow"
    actions = [
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey*",
      "kms:Decrypt*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "concourse-s3" {
  provider = aws.sandbox_account
  name   = "${var.environment_name}-concourse-s3-policy"
  policy = data.aws_iam_policy_document.concourse-s3.json
}

resource "aws_iam_role_policy_attachment" "concourse-s3" {
  provider = aws.sandbox_account
  role       = aws_iam_role.concourse.name
  policy_arn = aws_iam_policy.concourse-s3.arn
}

## outputs
## - pipeline_bucket_name = aws_s3_bucket.pipeline.bucket
## - pipeline_bucket_kms_key_id = aws_kms_key.pipeline.key_id
## - backup_bucket_name = aws_s3_bucket.backup.bucket
## - backup_bucket_kms_key_id = aws_kms_key.backup.key_id
