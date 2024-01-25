locals {
  config = {
    opsman_iam_instance_profile_name = aws_iam_instance_profile.opsman.name
    opsman_bucket_name = aws_s3_bucket.opsman.bucket
    concourse_iam_instance_profile_name = aws_iam_instance_profile.concourse.name
    pipeline_bucket_name = aws_s3_bucket.pipeline.bucket
    pipeline_bucket_kms_key_id = aws_kms_key.pipeline.key_id
    backup_bucket_name = aws_s3_bucket.backup.bucket
    backup_bucket_kms_key_id = aws_kms_key.backup.key_id
  }
}
output "config" {
  value     = jsonencode(local.config)
}
