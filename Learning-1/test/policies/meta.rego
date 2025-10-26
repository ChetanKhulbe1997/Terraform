package terraform.meta

# Meta tests for providers and outputs

# 9. Provider versions must be pinned via required_providers constraints in the root module
violation[msg] {
  not provider_versions_constrained
  msg := "Meta: required_providers constraints should be defined"
}

provider_versions_constrained {
  req := input.configuration.root_module.required_providers
  count(req) > 0
}

# 10. Must pass terraform validate (handled by runner); here we ensure there is at least one output for EC2 id or public_ip
violation[msg] {
  outs := input.configuration.root_module.outputs
  not outputs_contain_key(outs, "instance_id")
  not outputs_contain_key(outs, "public_ip")
  msg := "Meta: outputs should include instance_id or public_ip"
}

outputs_contain_key(outs, key) {
  some k
  k := keys(outs)[_]
  k == key
}
