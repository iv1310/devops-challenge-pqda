locals {
  create_buckets = {
    "bucket1" = {
      "bucket_name"    = "projectA-s3-bucket1"
      "lifecycle_days" = 7
      "group_name"     = "projectA-group1"
      "user_name"      = "projectA-user1"
      "policy_name"    = "projectA-bucket-policy1"
      "suffix_name"    = "dev"
    }
    "bucket2" = {
      "bucket_name"    = "projectA-s3-bucket2"
      "lifecycle_days" = 14
      "group_name"     = "projectA-group2"
      "user_name"      = "projectA-user2"
      "policy_name"    = "projectA-bucket-policy2"
      "suffix_name"    = "stag"
    }
  }
}

module "s3_buckets" {
  source = "./s3-modules"
  
  for_each = local.create_buckets
  
  create_bucket = true
  bucket_name   = each.value.bucket_name
  lifecycle_days = each.value.lifecycle_days
  group_name    = each.value.group_name
  user_name     = each.value.user_name
  policy_name   = each.value.policy_name
  suffix_name = each.value.suffix_name

  tags = {
    "Environment" = "dev"
    "DevOps" = "Ivan"
  }
}
