# ========================================
# Manage floating IPs in the Hetzner Cloud
# ========================================


# ------------
# Local Values
# ------------

locals {
  output_float_ips   = [
    for name, float_ip in hcloud_floating_ip.floating_ips : merge(float_ip, {
      "assignment" = try(hcloud_floating_ip_assignment.assignments[name], {}),
      "rdns"       = [
        for rdns in hcloud_rdns.floating_ip_rdns : rdns
          if(tostring(rdns.floating_ip_id) == float_ip.id)
      ]
    })
  ]

  output_rdns        = [
    for name, rdns in hcloud_rdns.floating_ip_rdns : merge(rdns, {
      "name"             = name
      "floating_ip_name" = try(local.rdns[name].floating_ip, null)
    })
  ]

  output_assignments = [
    for name, assignment in hcloud_floating_ip_assignment.assignments :
      merge(assignment, {
        "name"             = name
        "floating_ip_name" = try(local.assignments[name].floating_ip, null)
      })
  ]
}


# -------------
# Output Values
# -------------

output "floating_ips" {
  description = "A list of all floating IP objects."
  value = local.output_float_ips
}

output "floating_ip_ids" {
  description = "A map of all floating IP objects indexed by ID."
  value = {
    for float_ip in local.output_float_ips : float_ip.id => float_ip
  }
}

output "floating_ip_names" {
  description = "A map of all floating IP objects indexed by name."
  value = {
    for float_ip in local.output_float_ips : float_ip.name => float_ip
  }
}

output "floating_ip_rdns" {
  description = "A list of all floating IP RDNS objects."
  value = local.output_rdns
}

output "floating_ip_rdns_ids" {
  description = "A map of all floating IP RDNS objects indexed by ID."
  value = {
    for rdns in local.output_rdns : rdns.id => rdns
  }
}

output "floating_ip_rdns_names" {
  description = "A map of all floating IP RDNS objects indexed by name."
  value = {
    for rdns in local.output_rdns : rdns.name => rdns
  }
}

output "floating_ip_assignments" {
  description = "A list of all floating IP assignment objects."
  value       = local.output_assignments
}

output "floating_ip_assignment_ids" {
  description = "A map of all floating IP assignment objects indexed by ID."
  value       = {
    for assignment in local.output_assignments : assignment.id => assignment
  }
}

output "floating_ip_assignment_names" {
  description = "A map of all floating IP assignment objects indexed by name."
  value       = {
    for assignment in local.output_assignments : assignment.name => assignment
  }
}
