# TencentCloud Cloud Object Storage Terraform module

Terraform module which creates COS buckets on TencentCloud.

## Features

This module aims to implement ALL combinations of arguments supported by TencentCloud and latest stable version of Terraform:

- Create buckets
- 🚧 ACL(access control list)
- 🚧 Lifecycle Rules
- 🚧 Static Website
- CORS
- 🚧 Replication
- Logging
- Versioning
- Encryption

If there is a missing feature or a bug - [open an issue](https://github.com/StarUbiquitous/terraform-module-tencentcloud-cos/issues/new).

## Terraform versions

Recommended use Terraform 1.0 or later version of this module.

## Usage

```terraform

module "bucket" {
  source = "terraform-xnxk-modules/cos/tencentcloud"

  for_each = {
    for bucket in local.buckets : bucket.name => {
      name                 = "${bucket.name}-${var.appid}"
      acl                  = can(bucket.acl) ? bucket.acl : "private"
      log_enable           = can(bucket.log_enable) ? bucket.log_enable : false
      log_prefix           = can(bucket.log_prefix) ? bucket.log_prefix : ""
      log_target_bucket    = can(bucket.log_target_bucket) ? bucket.log_target_bucket : ""
      multi_az             = can(bucket.multi_az) ? bucket.multi_az : false
      encryption_algorithm = can(bucket.encryption_algorithm) ? bucket.encryption_algorithm : ""
      versioning_enable    = can(bucket.versioning_enable) ? bucket.versioning_enable : false
      cors_rules           = try(bucket.cors_rules, {})
      lifecycle_rules      = try(bucket.lifecycle_rules, [])
    }
  }
  bucket               = each.value.name
  acl                  = each.value.acl
  log_enable           = each.value.log_enable
  encryption_algorithm = each.value.encryption_algorithm
  multi_az             = each.value.multi_az
  versioning_enable    = each.value.versioning_enable
  cors_rules           = each.value.cors_rules
  lifecycle_rules      = each.value.lifecycle_rules
}

```

## Outputs

WIP

## License

The code in this repository, unless otherwise noted, is under the terms of both the [Anti 996](https://github.com/996icu/996.ICU/blob/master/LICENSE) License and the [Apache License (Version 2.0)](./LICENSE-APACHE).
