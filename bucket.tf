locals {
  cors_rules      = try(jsondecode(var.cors_rules), var.cors_rules)
  lifecycle_rules = try(jsondecode(var.lifecycle_rules), var.lifecycle_rules)
}

resource "tencentcloud_cos_bucket" "bucket" {
  bucket            = var.bucket
  acl               = var.acl
  log_enable        = var.log_enable
  log_prefix        = var.log_prefix
  log_target_bucket = var.log_target_bucket

  encryption_algorithm = var.encryption_algorithm

  versioning_enable = var.versioning_enable

  dynamic "cors_rules" {
    for_each = local.cors_rules.allowed_headers
    content {
      allowed_origins = try(local.cors_rules.allowed_origins, null)
      allowed_methods = try(local.cors_rules.allowed_methods, null)
      allowed_headers = try(local.cors_rules.allowed_headers, null)
      expose_headers  = try(local.cors_rules.expose_headers, null)
      max_age_seconds = try(local.cors_rules.max_age_seconds, null)
    }
  }

  dynamic "lifecycle_rules" {
    for_each = local.lifecycle_rules
    content {
      filter_prefix = try(local.lifecycle_rules.filter_prefix, null)

      transition {
        date          = try(local.lifecycle_rules.transition.date, null)
        storage_class = try(local.lifecycle_rules.transition.storage_class, null)
      }

      expiration {
        days = try(local.lifecycle_rules.expiration.days, null)
      }
    }
  }
}
