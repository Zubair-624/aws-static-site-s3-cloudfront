#----------Bucket Name----------
# CONSOLE: Create bucket → General configuration → Bucket name
# The name you typed in the "Bucket name" field
variable "bucket_name" {

    description = "Name of the S3 bucket — must be globally unique"
    type = string
  
}