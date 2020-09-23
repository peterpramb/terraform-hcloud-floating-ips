# =========================================
# Manages floating IPs in the Hetzner Cloud
# =========================================


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
        for rdns in hcloud_rdns.floating_ips : rdns if(tostring(rdns.floating_ip_id) == float_ip.id)
      ]
    })
  ]
}

output "floating_ip_rdns_ids" {
  description = "A map of all floating IP rdns ids and associated names."
  value = {
    for name, rdns in hcloud_rdns.floating_ips : rdns.id => name
  }
}

output "floating_ip_rdns_names" {
  description = "A map of all floating IP rdns names and associated ids."
  value = {
    for name, rdns in hcloud_rdns.floating_ips : name => rdns.id
  }
}

output "floating_ip_rdns" {
  description = "A list of all floating IP rdns objects."
  value = [
    for rdns in hcloud_rdns.floating_ips : rdns
  ]
}
