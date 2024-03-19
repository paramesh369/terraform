# To create a S3 bucket:

resource "aws_s3_bucket" "dev-bucket" {
  bucket = "my-param-bucket"
}

# To block the public access
resource "aws_s3_bucket_public_access_block" "dev-bucket" {
  bucket = aws_s3_bucket.dev-bucket.id

  block_public_acls       = false #For unblocking public acces keep false as false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# To enable the Access contol Lists(ACLs) and add the rule
resource "aws_s3_bucket_ownership_controls" "dev-bucket" {
  bucket = aws_s3_bucket.dev-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# To upload the object to the bucket

resource "aws_s3_object" "object-1" {
  bucket = aws_s3_bucket.dev-bucket.id
  key = "dog"
  source = "C:/Users/sadhu/OneDrive/Desktop/dog.jpg"
}