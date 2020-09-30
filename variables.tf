variable "expiration" {
  default     = 2555
  description = "The number of days to wait before expiring an object"
  type        = number
}

variable "name_prefix" {
  description = "The name prefix to use when creating resource names"
  type        = string
}

variable "transition_to_glacier" {
  default     = 30
  description = "The number of days to wait before transitioning an object to Glacier"
  type        = number
}

variable "block_public_acls" {
  default     = true
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
}

variable "block_public_policy" {
  default     = true
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
}

variable "ignore_public_acls" {
  default     = true
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
}

variable "restrict_public_buckets" {
  default     = true
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
}