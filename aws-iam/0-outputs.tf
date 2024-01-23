locals {
  config = {
    opsman_iam_instance_profile_name = aws_iam_instance_profile.opsman.name
    concourse_iam_instance_profile_name = aws_iam_instance_profile.concourse.name
    tas_cc_iam_instance_profile_name = aws_iam_instance_profile.tas-cc.name
  }
}
output "config" {
  value     = jsonencode(local.config)
}
