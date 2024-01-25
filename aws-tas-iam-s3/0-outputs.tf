locals {
  config = {
    opsman_iam_instance_profile_name = aws_iam_instance_profile.opsman.name
    opsman_bucket_name = aws_s3_bucket.opsman.bucket
    tas_cc_iam_instance_profile_name = aws_iam_instance_profile.tas-cc.name
    tas_cc_packages_bucket_name = aws_s3_bucket.packages.bucket
    tas_cc_resources_bucket_name = aws_s3_bucket.resources.bucket
    tas_cc_buildpacks_bucket_name = aws_s3_bucket.buildpacks.bucket
    tas_cc_droplets_bucket_name = aws_s3_bucket.droplets.bucket
    tas_cc_packages_backup_bucket_name = aws_s3_bucket.packages-backup.bucket
    tas_cc_buildpacks_backup_bucket_name = aws_s3_bucket.buildpacks-backup.bucket
    tas_cc_droplets_backup_bucket_name = aws_s3_bucket.droplets-backup.bucket
    tas_cc_buckets_kms_key_id = aws_kms_key.tas-cc.key_id
  }
}
output "config" {
  value     = jsonencode(local.config)
}
