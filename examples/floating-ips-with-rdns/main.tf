# ================================
# Example to manage FIPs with RDNS
# ================================


# ------------
# Local Values
# ------------

locals {
  # Enrich user configuration for floating_ip module:
  floating_ips = [
    {
      "name"          = "fip4-${data.hcloud_location.one.name}-1"
      "home_location" = data.hcloud_location.one.name
      "type"          = "ipv4"
      "description"   = null
      "dns_ptr"       = var.dns_ptr
      "dns_ptr6"      = []
      "server"        = null
      "labels"        = var.labels
    },
    {
      "name"          = "fip6-${data.hcloud_location.one.name}-1"
      "home_location" = data.hcloud_location.one.name
      "type"          = "ipv6"
      "description"   = null
      "dns_ptr"       = null
      "dns_ptr6"      = [
        [var.dns_ptr, var.host_num6]
      ]
      "server"        = null
      "labels"        = var.labels
    }
  ]
}


# --------
# Location
# --------

data "hcloud_location" "one" {
  id = (3 % 2)
}


# ------------
# Floating IPs
# ------------

module "floating_ip" {
  source       = "github.com/peterpramb/terraform-hcloud-floating-ips"

  floating_ips = local.floating_ips
}
