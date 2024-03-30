output "bucket_id" {
  description = "The ID of the created S3 bucket"
  value       = try(aws_s3_bucket.this[0].id, "")
}

output "group_name" {
  description = "The name of the created IAM group"
  value       = try(aws_iam_group.this[0].name, "")
}

output "user_name" {
  description = "The name of the created IAM user"
  value       = try(aws_iam_user.this[0].name, "")
}

output "policy_id" {
  description = "The ID of the created IAM policy"
  value       = try(aws_iam_policy.this[0].id, "")
}

output "policy_arn" {
  description = "The ARN of the created IAM policy"
  value       = try(aws_iam_policy.this[0].arn, "")
}
