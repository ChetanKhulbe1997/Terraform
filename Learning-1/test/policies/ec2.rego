package terraform.ec2

# Helper to get planned resources of a specific type
resource_changes_by_type(type) = resources {
  resources := [rc | rc := input.resource_changes[_]; rc.type == type]
}

# Helper to get all instance objects in the plan after change
instances_after(resources) = instances {
  instances := [inst |
    some rc in resources
    some change := rc.change
    some after := change.after
    inst := after
  ]
}

# 1. Should create exactly one EC2 instance with expected attributes
violation["EC2: expected exactly one aws_instance to be planned"] {
  resources := resource_changes_by_type("aws_instance")
  count(resources) != 1
}

# 2. Should attach the configured key pair to the EC2 instance
violation[msg] {
  resources := resource_changes_by_type("aws_instance")
  count(resources) == 1
  instances := instances_after(resources)
  some i; inst := instances[i]
  not inst.key_name
  msg := "EC2: instance key_name must be set"
}

# 3. Should tag the EC2 instance with Name and Environment tags
violation[msg] {
  resources := resource_changes_by_type("aws_instance")
  count(resources) == 1
  instances := instances_after(resources)
  inst := instances[_]
  not inst.tags.Name
  msg := "EC2: instance must have Name tag"
}

violation[msg] {
  resources := resource_changes_by_type("aws_instance")
  count(resources) == 1
  instances := instances_after(resources)
  inst := instances[_]
  not inst.tags.Environment
  msg := "EC2: instance must have Environment tag"
}

# 4. Should associate a security group and avoid wide-open SSH (0.0.0.0/0 on 22)
# We check sg resources as well as inline vpc_security_group_ids presence
violation[msg] {
  resources := resource_changes_by_type("aws_instance")
  count(resources) == 1
  instances := instances_after(resources)
  inst := instances[_]
  not inst.vpc_security_group_ids
  not inst.security_groups
  msg := "EC2: instance should be associated with a security group"
}

# Check SG ingress rules for 0.0.0.0/0 on port 22
# This inspects any aws_security_group resources in the plan. If none are managed here,
# this rule will not error unless such SGs are present and open.
violation[msg] {
  sgs := resource_changes_by_type("aws_security_group")
  some sg in sgs
  after := sg.change.after
  ingress := after.ingress[_]
  ports := [p | p := ports_from_block(ingress)]
  some p in ports
  p.protocol != "-1"
  p.from_port <= 22
  p.to_port >= 22
  cidr := ingress.cidr_blocks[_]
  cidr == "0.0.0.0/0"
  msg := "EC2: security group allows SSH from 0.0.0.0/0"
}

# Ports extraction helper for SG blocks (handles lists or single values)
ports_from_block(b) = p {
  p := {
    "from_port": default_to_int(b.from_port, -1),
    "to_port": default_to_int(b.to_port, -1),
    "protocol": default_to_string(b.protocol, "-1")
  }
}

# 5. Should use a user_data script
violation[msg] {
  resources := resource_changes_by_type("aws_instance")
  count(resources) == 1
  inst := instances_after(resources)[_]
  not inst.user_data
  not inst.user_data_base64
  msg := "EC2: instance should provide user_data or user_data_base64"
}

# 6. Should output the EC2 public IP or instance ID
# This is cross-checked in meta.rego using output resources. Kept here as a soft reminder.

# Utility: default value helpers
default_to_int(x, d) = out {
  out := x
} else = out {
  out := d
}

default_to_string(x, d) = out {
  out := x
} else = out {
  out := d
}
