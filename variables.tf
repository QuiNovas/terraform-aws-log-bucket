variable "expiration" {
  default     = 2555
  description = "The number of days to wait before expiring an object"
  type        = "string"
}

variable "name_prefix" {
  description = "The name prefix to use when creating resource names"
  type        = "string"
}

variable "transition_to_glacier" {
  default     = 30
  description = "The number of days to wait before transitioning an object to Glacier"
  type        = "string"
}