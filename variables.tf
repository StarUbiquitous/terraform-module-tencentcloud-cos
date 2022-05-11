variable "bucket" {
  type = string
}

variable "acl" {
  default     = "private"
  description = "The ACL to use for the bucket"
  type        = string
}

variable "multi_az" {
  default     = false
  description = "Whether to enable multi-az"
  type        = bool
}

variable "versioning_enable" {
  default     = false
  description = "Enable versioning on the bucket"
  type        = bool
}

variable "cors_rules" {
  default     = {}
  description = "The CORS rules to apply to the bucket"
}

variable "lifecycle_rules" {
  default     = {}
  description = "The lifecycle rules to apply to the bucket"
}
