resource "aws_s3_bucket" "bosh" {
  bucket_prefix = "${var.environment_name}-bosh-"
}

resource "aws_s3_bucket_versioning" "bosh" {
  bucket = aws_s3_bucket.bosh.id
  versioning_configuration {
    status = "Enabled"
  }
}

# VPC endpoint for S3 access
resource "aws_vpc_endpoint" "s3" {
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = aws_subnet.private[*].id
  service_name       = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [ aws_security_group.plane.id ]
  tags = {
    Name = "${var.environment_name}-vpc-s3-endpoint"
  }
}
