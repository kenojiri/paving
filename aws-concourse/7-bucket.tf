resource "random_integer" "bosh_bucket_suffix" {
  min = 1
  max = 100000
}

resource "aws_s3_bucket" "bosh" {
  bucket = "${var.environment_name}-bosh-${random_integer.bosh_bucket_suffix.result}"
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-bosh-${random_integer.bosh_bucket_suffix.result}" },
  )
}

resource "aws_s3_bucket_versioning" "bosh" {
  bucket = aws_s3_bucket.bosh.id
  versioning_configuration {
    status = "Enabled"
  }
}
