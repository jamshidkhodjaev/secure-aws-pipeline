resource "aws_s3_bucket" "lab_bucket" {
  bucket_prefix = "secure-lab-bucket-"
  force_destroy = true
}

# INTENTIONALLY MISCONFIGURED FOR TESTING:
# Public Access Block removed to trigger Trivy AVD-AWS-0086 / AVD-AWS-0093 detection

resource "aws_s3_bucket_versioning" "lab_bucket_versioning" {
  bucket = aws_s3_bucket.lab_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab_bucket_crypto" {
  bucket = aws_s3_bucket.lab_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
