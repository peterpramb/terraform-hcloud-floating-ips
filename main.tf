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

  # Build a map of all provided floating IP RDNS objects, indexed by floating
  # IP name (for IPv4), or floating IP name and hostnum (for IPv6). With IPv6,
  # append each provided hostnum to the provisioned IPv6 network to form the
  # final IPv6 address:
  rdns        = merge(
    {
      for float_ip in local.float_ips : float_ip.name => merge(float_ip, {
        "floating_ip" = float_ip.name
        "ip_address"  = hcloud_floating_ip.floating_ips[float_ip.name].ip_address
      }) if(float_ip.type == "ipv4" &&
           try(float_ip.dns_ptr, null) != null && float_ip.dns_ptr != "")
    },
    {
      for float_ip in flatten([
        for float_ip in local.float_ips : [
          for rdns in float_ip.dns_ptr6 : merge(float_ip, {
            "dns_ptr"     = rdns[0]
            "floating_ip" = float_ip.name
            "host_num6"   = rdns[1]
            "ip_address"  = format("%s%s",
              hcloud_floating_ip.floating_ips[float_ip.name].ip_address,
              rdns[1])
          }) if(try(float_ip.dns_ptr6, null) != null && rdns[0] != "" &&
               rdns[1] != "")
        ] if(float_ip.type == "ipv6")
      ]) : "${float_ip.name}:${float_ip.host_num6}" => float_ip
    }
  )

  # Build a map of all provided floating IP objects to be assigned, indexed
  # by floating IP name:
  assignments = {
    for float_ip in local.float_ips : float_ip.name => merge(float_ip, {
      "floating_ip" = float_ip.name
    }) if(try(float_ip.server_id, null) != null && float_ip.server_id != "")
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
  ip_address     = each.value.ip_address
}


# ----------------------
# Floating IP Assignment
# ----------------------

resource "hcloud_floating_ip_assignment" "assignments" {
   for_each       = local.assignments

   floating_ip_id = hcloud_floating_ip.floating_ips[each.value.name].id
   server_id      = each.value.server_id
}
