# Basic S3 bucket configuration:
# region, bucket type, and bucket name
resource "aws_s3_bucket" "website" {

    tags = {
        Name = "${var.project_name}-s3-bucket"
    }
  
}

# Bucket owner owns all uploaded files
# ACLs are disabled for simpler security
resource "aws_s3_bucket_ownership_controls" "website" {

    bucket = aws_s3_bucket.website.id

    rule {
      object_ownership = "BucketOwnerEnforced"
    }
  
}

# Keeps the S3 bucket private
# Blocks all public access to the bucket
resource "aws_s3_bucket_public_access_block" "website" {

    bucket = aws_s3_bucket.website.id

    block_public_acls = true
    ignore_public_acls = true
    
    block_public_policy = true
    restrict_public_buckets = true 
  
}

#-----
# Versioning is not enabled
# AWS stores only the latest version of each file
#-----

#-----
# S3 automatically encrypts data by default
# No extra setup is required
#-----


#-----
# Object Lock is OFF
# No need for this setup in this project
#-----

#-----Create Bucket-----



# Uploads index.html into the S3 bucket
# Terraform does this automatically instead of manual upload
resource "aws_s3_object" "index" {

    bucket = aws_s3_bucket.website

    # Name column in Console
    key = "index.html"
    source = "${path.module}/../index.html"

    # Type column shows "html"
    content_type = "text/html"

    # Storage class column shows "Standard"
    storage_class = "STANDARD"
  
}

# Allows only CloudFront to read files from the bucket
# Blocks all other access
resource "aws_s3_bucket_policy" "website" {

    bucket = aws_s3_bucket.website.id
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid    = "AllowCloudFrontServicePrincipal"
                Effect = "Allow"
                Principal = {
                    Service = "cloudfront.amazonaws.com"
                }
                Action   = "s3:GetObject"
                Resource = "${aws_s3_bucket.website.arn}/*"
                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = var.cloudfront_distribution_arn
                    }
                }
            }
        ]
    })
  
}

