variable "create_bucket" {
  description = "Create bucket or not?"
  type        = bool
  default     = true
}

variable "suffix_name" {
  description = "Suffix name for all resources."
  type        = string
}

variable "bucket_name" {
  description = "Name for the S3 bucket"
  type        = string
}

variable "object_lock_enabled" {
  description = "Enable object lock or not"
  type        = bool
  default     = false
}

variable "lifecycle_days" {
  description = "Number of days after which objects should be deleted"
  default     = 7
  type        = number
}

variable "force_destroy" {
  description = "Configuration for the S3 bucket"
  type        = bool
  default     = false
}

variable "policy_name" {
  description = "Name for the IAM policy"
  type        = string
}

variable "group_name" {
  description = "Name for the IAM group"
  type        = string
}

variable "user_name" {
  description = "Name for the IAM user"
  type        = string
}

variable "tags" {
  description = "Default tags."
  type        = any
  default     = {}
}
