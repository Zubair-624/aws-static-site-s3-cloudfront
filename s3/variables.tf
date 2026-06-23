#----------Project Name----------
variable "project_name" {

    description = "Name of the S3 bucket — must be globally unique"
    type = string
  
}

# CloudFront distribution ARN
# Used in the S3 bucket policy to allow access only from our CloudFront distribution
variable "cloudfront_distribution_arn" {

    description = "ARN of the CloudFront distribution allowed to access this bucket"
    type = string
  
}