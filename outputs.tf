# ========================================
# Manage floating IPs in the Hetzner Cloud
# ========================================


# -------------
# Output Values
# -------------

output "floating_ip_ids" {
  description = "A map of all floating IP ids and associated names."
  value = {
    for name, float_ip in hcloud_floating_ip.floating_ips : float_ip.id => name
  }
}

output "floating_ip_names" {
  description = "A map of all floating IP names and associated ids."
  value = {
    for name, float_ip in hcloud_floating_ip.floating_ips : name => float_ip.id
  }
}

output "floating_ips" {
  description = "A list of all floating IP objects."
  value = [
    for float_ip in hcloud_floating_ip.floating_ips : merge(float_ip, {
      "rdns" = [
        for rdns in hcloud_rdns.floating_ip_rdns : rdns
          if(tostring(rdns.floating_ip_id) == float_ip.id)
      ]
    })
  ]
}

output "floating_ip_rdns_ids" {
  description = "A map of all floating IP rdns ids and associated names."
  value = {
    for name, rdns in hcloud_rdns.floating_ip_rdns : rdns.id => name
  }
}

output "floating_ip_rdns_names" {
  description = "A map of all floating IP rdns names and associated ids."
  value = {
    for name, rdns in hcloud_rdns.floating_ip_rdns : name => rdns.id
  }
}

output "floating_ip_rdns" {
  description = "A list of all floating IP rdns objects."
  value = [
    for rdns in hcloud_rdns.floating_ip_rdns : rdns
  ]
}

output "floating_ip_assignment_ids" {
  description = "A map of all floating IP assignment ids and associated names."
  value       = {
    for name, assignment in hcloud_floating_ip_assignment.assignments :
      assignment.id => name
  }
}

output "floating_ip_assignment_names" {
  description = "A map of all floating IP assignment names and associated ids."
  value       = {
    for name, assignment in hcloud_floating_ip_assignment.assignments :
      name => assignment.id
  }
}

output "floating_ip_assignments" {
  description = "A list of all floating IP assignment objects."
  value       = [
    for name, assignment in hcloud_floating_ip_assignment.assignments :
      merge(assignment, {
        "floating_ip_name" = lookup(lookup(local.assignments, name, {}), "name",
                                    null)
      })
  ]
}
