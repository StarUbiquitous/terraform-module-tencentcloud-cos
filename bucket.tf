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
    for_each = lookup(local.cors_rules, "allowed_headers", [])
    content {
      allowed_origins = lookup(local.cors_rules, "allowed_origins", ["*"])
      allowed_methods = lookup(local.cors_rules, "allowed_methods", [
        "PUT",
        "GET",
        "POST",
        "DELETE",
        "HEAD",
      ])
      allowed_headers = lookup(local.cors_rules, "allowed_headers", ["*"])
      expose_headers = lookup(local.cors_rules, "expose_headers", [
        "ETag",
        "Content-Length",
        "x-cos-request-id",
      ])
      max_age_seconds = lookup(local.cors_rules, "max_age_seconds", 600)
    }
  }

  dynamic "lifecycle_rules" {
    for_each = length(local.lifecycle_rules) == 0 ? [] : local.lifecycle_rules
    content {
      filter_prefix = lookup(lifecycle_rules.value, "filter_prefix", "*")

      dynamic "transition" {
        for_each = lookup(lifecycle_rules.value, "transition", [])
        content {

          days = lookup(lifecycle_rules.value.transition, "days", "")

          storage_class = lookup(lifecycle_rules.value.transition, "storage_class", "STANDARD")
        }
      }

      dynamic "expiration" {
        for_each = lookup(lifecycle_rules.value, "expiration", [])
        content {

          date = lookup(lifecycle_rules.value.expiration, "days", "")

        }
      }
    }
  }
}
