# S3 bucket name created by this module
# Exported so the root module or other modules can use it without hardcoding the bucket name
output "project_name" {

    description = "Name of the S3 Bucket"
    value = aws_s3_bucket.website.id 
  
}

# S3 bucket address (REST endpoint)
# CloudFront uses this address to locate the bucket, and OAC provides the permission to access it.
# Address = where S3 is
# OAC     = permission to enter
output "bucket_regional_domain_name" {

    description = "S3 REST endpoint — used as CloudFront origin domain"
    value = aws_s3_bucket.website.bucket_regional_domain_name
  
}

# S3 bucket ARN (unique AWS ID)
# Used by other modules when they need to create permissions for this bucket
output "bucket_arn" {
    
    description = "Full ARN of the S3 bucket"
    value = aws_s3_bucket.website.arn
}