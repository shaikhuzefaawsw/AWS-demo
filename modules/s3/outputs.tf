###############################################################
# modules/s3/outputs.tf
###############################################################
output "document_bucket_name" {
  value = aws_s3_bucket.documents.bucket
}

output "document_bucket_arn" {
  value = aws_s3_bucket.documents.arn
}
