# -------------------------------------------------------
# CONSOLE: Create bucket → General configuration
# → AWS Region: US East (N. Virginia) us-east-1
# → Bucket type: General purpose (selected by default)
# → Bucket namespace: Global namespace (selected by default)
# → Bucket name: you typed your bucket name here
# -------------------------------------------------------
resource "aws_s3_bucket" "website" {

    tags = {
        Name = "${var.bucket_name}-se-bucket"
    }
  
}

# -------------------------------------------------------
# CONSOLE: Create bucket → Object Ownership
# → ACLs disabled (recommended) ← this was selected
# → Object Ownership: Bucket owner enforced
# You did NOT change this — it was the default
# -------------------------------------------------------
resource "aws_s3_bucket_ownership_controls" "website" {

    bucket = aws_s3_bucket.website.id

    rule {
      object_ownership = "BucketOwnerEnforced"
    }
  
}

# -------------------------------------------------------
# CONSOLE: Create bucket → Block Public Access settings
# → Block all public access ← big checkbox was ON
# Turning this ON automatically enables all 4 sub-settings:
#   - Block public access via new ACLs
#   - Block public access via any ACLs
#   - Block public access via new bucket/access point policies
#   - Block public and cross-account access via any policies
# This is why S3 stays private — nobody hits it directly
# -------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "website" {

    bucket = aws_s3_bucket.website.id

    block_public_acls = true
    ignore_public_acls = true
    
    block_public_policy = true
    restrict_public_buckets = true 
  
}

# -------------------------------------------------------
# CONSOLE: Create bucket → Bucket Versioning
# → Disable ← was selected (you did not enable it)
# Not needed for a static site — we just serve one version

# Versioning is disabled by default in AWS — no Terraform
# resource needed. Shown here so you know where it maps.
#-------------------------------------------------------

# -------------------------------------------------------
# CONSOLE: Create bucket → Default encryption
# → Encryption type: Server-side encryption with
#   Amazon S3 managed keys (SSE-S3) ← selected by default
# → Bucket Key: Enable ← selected by default
# AWS applies this automatically — no extra resource needed
# -------------------------------------------------------

# -------------------------------------------------------
# CONSOLE: Create bucket → Advanced settings → Object Lock
# → Disable ← was selected (default)
# Not needed for this project
# -------------------------------------------------------


#-----Create Bucket-----



# -------------------------------------------------------
# CONSOLE: S3 → Buckets → my-static-site-zubair
# → Objects tab (the screen you are on right now)
# → You clicked the orange "Upload" button (top right)
# → Add files → selected index.html → clicked Upload
#
# What you see after upload on this screen:
# Name:          index.html
# Type:          html
# Size:          2.8 KB
# Storage class: Standard  ← this is what content_type maps to
# Last modified: June 22, 2026 02:41:53
#
# Terraform does this exact upload automatically on apply
# The "key" below = the Name column in the Console
# The "content_type" below = the Type column in the Console
# -------------------------------------------------------
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

# -------------------------------------------------------
# CONSOLE: S3 → your bucket → Permissions tab
# → Bucket policy section → Edit → paste policy → Save
# This policy says: ONLY our CloudFront distribution
# is allowed to read files from this bucket.
# Everyone else gets: Access Denied
# -------------------------------------------------------
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

