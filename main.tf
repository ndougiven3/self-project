resource "aws_s3_bucket" "example" {
  bucket = "my-uni-bucket-name-123451234456"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "amplify-wheelspin-staging-155819-deployment" {
  bucket        = "amplify-wheelspin-staging-155819-deployment"

  # Grants
  grant {
    id          = "dd5f9596849865b5764bd21abf59e8dc0ebe957c5a10a9729095078c0da10b1a"
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  # Versioning
  versioning {
    enabled    = false
    mfa_delete = false
  }
  tags = {
    "user:Application" = "wheelspin"
    "user:Stack" = "staging"
  }

  # Encryption
  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
        kms_master_key_id = null
      }
    }
  }

  # Request payer
  request_payer = "BucketOwner"
}
