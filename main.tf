# ========================================
# Manage floating IPs in the Hetzner Cloud
# ========================================


# ------------
# Local Values
# ------------

locals {
  # Build a map of all provided floating IP objects, indexed by floating IP
  # name:
  float_ips   = {
    for float_ip in var.floating_ips : float_ip.name => float_ip
  }

  # Build a map of all provided floating IP objects with RDNS, indexed by
  # floating IP name:
  rdns        = {
    for float_ip in local.float_ips : float_ip.name => float_ip
      if(lookup(float_ip, "dns_ptr", null) != null && float_ip.dns_ptr != "")
  }

  # Build a map of all provided floating IP objects to be assigned, indexed
  # by floating IP name and server ID:
  assignments = {
    for float_ip in local.float_ips :
      "${float_ip.name}:${float_ip.server_id}" => float_ip
        if(lookup(float_ip, "server_id", null) != null &&
           float_ip.server_id != "")
  }
}


# ------------
# Floating IPs
# ------------

resource "hcloud_floating_ip" "floating_ips" {
  for_each      = local.float_ips

  name          = each.value.name
  home_location = each.value.home_location
  type          = each.value.type
  description   = each.value.description

  labels        = each.value.labels
}


# ----------------
# Floating IP RDNS
# ----------------

resource "hcloud_rdns" "floating_ip_rdns" {
  for_each       = local.rdns

  dns_ptr        = each.value.dns_ptr
  floating_ip_id = hcloud_floating_ip.floating_ips[each.value.name].id
  ip_address     = (each.value.type == "ipv6" && each.value.host_num6 != null ?
    format("%s%s",
           hcloud_floating_ip.floating_ips[each.value.name].ip_address,
           each.value.host_num6) :
    hcloud_floating_ip.floating_ips[each.value.name].ip_address
  )
}


# ----------------------
# Floating IP Assignment
# ----------------------

resource "hcloud_floating_ip_assignment" "assignments" {
   for_each       = local.assignments

   floating_ip_id = hcloud_floating_ip.floating_ips[each.value.name].id
   server_id      = each.value.server_id
}
