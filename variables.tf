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

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}