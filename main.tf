# =========================================
# Manages floating IPs in the Hetzner Cloud
# =========================================


# ------------
# Local Values
# ------------

locals {
  # Build a map of all provided floating IP objects, indexed by floating IP name
  float_ips = {
    for float_ip in var.floating_ips : float_ip.name => float_ip
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

resource "hcloud_rdns" "floating_ips" {
  for_each       = {
    for name, float_ip in hcloud_floating_ip.floating_ips : name => merge(float_ip, {
      "dns_ptr" = local.float_ips[name].dns_ptr
    }) if(lookup(local.float_ips[name], "dns_ptr", null) != null &&
         local.float_ips[name].dns_ptr != ""))
  }

  dns_ptr        = each.value.dns_ptr
  floating_ip_id = each.value.id
  ip_address     = each.value.ip_address
}
