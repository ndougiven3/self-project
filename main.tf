// ...existing code...
resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 30

  tags = {
    Name = "s3-encryption-key"
  }
}

resource "aws_s3_bucket" "access_logs" {
  bucket = "self-project-s3-access-logs-12345" # adjust to a globally-unique name
  acl    = "log-delivery-write"

  tags = {
    Name        = "s3-access-logs"
    Environment = "infra"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-uni-bucket-name-123451234456"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3.arn
      }
      bucket_key_enabled = true
    }
  }

  logging {
    target_bucket = aws_s3_bucket.access_logs.id
    target_prefix = "example/"
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "amplify-wheelspin-staging-155819-deployment" {
  bucket = "amplify-wheelspin-staging-155819-deployment"

  # Grants
  grant {
    id          = "dd5f9596849865b5764bd21abf59e8dc0ebe957c5a10a9729095078c0da10b1a"
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  # Versioning
  versioning {
    enabled    = true
    mfa_delete = false
  }

  tags = {
    "user:Application" = "wheelspin"
    "user:Stack"       = "staging"
  }

  # Encryption with customer managed KMS
  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = true

      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3.arn
      }
    }
  }

  # Request payer
  request_payer = "BucketOwner"

  logging {
    target_bucket = aws_s3_bucket.access_logs.id
    target_prefix = "amplify-wheelspin-staging/"
  }
}

resource "aws_s3_bucket_public_access_block" "amplify_wheelspin" {
  bucket = aws_s3_bucket.amplify-wheelspin-staging-155819-deployment.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = true
}
// ...existing code...