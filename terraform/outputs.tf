output "role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "IAM Role ARN for GitHub Actions OIDC"
}

output "bucket_name" {
  value       = aws_s3_bucket.lab_bucket.id
  description = "Name of the created S3 bucket"
}
