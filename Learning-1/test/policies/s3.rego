package terraform.s3

# Helper to get resources by type
resource_changes_by_type(type) = resources {
  resources := [rc | rc := input.resource_changes[_]; rc.type == type]
}

instances_after(resources) = instances {
  instances := [after |
    some rc in resources
    some change := rc.change
    some after := change.after
  ]
}

# 7. S3 bucket must have versioning enabled
violation[msg] {
  buckets := resource_changes_by_type("aws_s3_bucket")
  count(buckets) > 0
  after := buckets[_].change.after
  not has_versioning_enabled(after)
  msg := "S3: bucket versioning must be enabled"
}

has_versioning_enabled(after) {
  v := after.versioning
  v.enabled == true
}

# 8. S3 bucket public access must be blocked (using either bucket-level blocks or aws_s3_bucket_public_access_block)
violation[msg] {
  # Check for dedicated public access block resource
  pabs := resource_changes_by_type("aws_s3_bucket_public_access_block")
  count(resource_changes_by_type("aws_s3_bucket")) > 0
  count(pabs) == 0
  not bucket_has_strict_public_access_block
  msg := "S3: public access should be blocked (no aws_s3_bucket_public_access_block found)"
}

bucket_has_strict_public_access_block {
  pabs := resource_changes_by_type("aws_s3_bucket_public_access_block")
  some pab in pabs
  after := pab.change.after
  after.block_public_acls == true
  after.block_public_policy == true
  after.ignore_public_acls == true
  after.restrict_public_buckets == true
}
