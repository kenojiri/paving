## inputs
## - environment_name

resource "aws_s3_bucket" "packages" {
  bucket_prefix = "${var.environment_name}-packages-"
}

resource "aws_s3_bucket" "resources" {
  bucket_prefix = "${var.environment_name}-resources-"
}

resource "aws_s3_bucket" "buildpacks" {
  bucket_prefix = "${var.environment_name}-buildpacks-"
}

resource "aws_s3_bucket" "droplets" {
  bucket_prefix = "${var.environment_name}-droplets-"
}

resource "aws_s3_bucket" "packages-backup" {
  bucket_prefix = "${var.environment_name}-packages-backup-"
}

resource "aws_s3_bucket" "buildpacks-backup" {
  bucket_prefix = "${var.environment_name}-buildpacks-backup-"
}

resource "aws_s3_bucket" "droplets-backup" {
  bucket_prefix = "${var.environment_name}-droplets-backup-"
}


resource "aws_kms_key" "tas-cc" {
  description = "This key is used to encrypt objects in TAS cloud controller buckets"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "tas-cc-alias" {
  name = "alias/${var.environment_name}-tas-cc"
  target_key_id = aws_kms_key.tas-cc.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "packages" {
  bucket = aws_s3_bucket.packages.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tas-cc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "resources" {
  bucket = aws_s3_bucket.resources.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tas-cc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "buildpacks" {
  bucket = aws_s3_bucket.buildpacks.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tas-cc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "droplets" {
  bucket = aws_s3_bucket.droplets.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tas-cc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "packages-backup" {
  bucket = aws_s3_bucket.packages-backup.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tas-cc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "buildpacks-backup" {
  bucket = aws_s3_bucket.buildpacks-backup.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tas-cc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "droplets-backup" {
  bucket = aws_s3_bucket.droplets-backup.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tas-cc.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


data "aws_iam_policy_document" "tas-cc-s3" {
  statement {
    sid     = "S3Permissions"
    effect  = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.packages.arn,
      aws_s3_bucket.resources.arn,
      aws_s3_bucket.buildpacks.arn,
      aws_s3_bucket.droplets.arn,
      aws_s3_bucket.packages-backup.arn,
      aws_s3_bucket.buildpacks-backup.arn,
      aws_s3_bucket.droplets-backup.arn,
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

resource "aws_iam_policy" "tas-cc-s3" {
  name   = "${var.environment_name}-tas-cc-policy"
  policy = data.aws_iam_policy_document.tas-cc-s3.json
}

resource "aws_iam_role_policy_attachment" "tas-cc-s3" {
  role       = aws_iam_role.tas-cc.name
  policy_arn = aws_iam_policy.tas-cc-s3.arn
}

## outputs
## - tas_cc_packages_bucket_name = aws_s3_bucket.packages.bucket
## - tas_cc_resources_bucket_name = aws_s3_bucket.resources.bucket
## - tas_cc_buildpacks_bucket_name = aws_s3_bucket.buildpacks.bucket
## - tas_cc_droplets_bucket_name = aws_s3_bucket.droplets.bucket
## - tas_cc_packages_backup_bucket_name = aws_s3_bucket.packages-backup.bucket
## - tas_cc_buildpacks_backup_bucket_name = aws_s3_bucket.buildpacks-backup.bucket
## - tas_cc_droplets_backup_bucket_name = aws_s3_bucket.droplets-backup.bucket
## - tas_cc_buckets_kms_key_id = aws_kms_key.tas-cc.key_id
