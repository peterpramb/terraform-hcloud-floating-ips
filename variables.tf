# ========================================
# Manage floating IPs in the Hetzner Cloud
# ========================================


# ---------------
# Input Variables
# ---------------

variable "floating_ips" {
  description = "The list of floating IP objects to be managed. Each floating IP object supports the following parameters: 'name' (string, required), 'home_location' (string, required), 'type' (string, required), 'description' (string, optional), 'dns_ptr' (string, IPv4 only, optional), 'dns_ptr6' (list of name/hostnum tuples, IPv6 only, optional), 'server_id' (string, optional), 'labels' (map of KV pairs, optional)."

  type        = list(
    object({
      name          = string
      home_location = string
      type          = string
      description   = string
      dns_ptr       = string
      dns_ptr6      = list(tuple([string, string]))
      server_id     = string
      labels        = map(string)
    })
  )

  default     = [
    {
      name          = "fip4-nbg1-1"
      home_location = "nbg1"
      type          = "ipv4"
      description   = null
      dns_ptr       = null
      dns_ptr6      = []
      server_id     = null
      labels        = {}
    }
  ]

  validation {
    condition     = can([
      for float_ip in var.floating_ips : regex("\\w+", float_ip.name)
    ])
    error_message = "All floating IPs must have a valid 'name' attribute specified."
  }

  validation {
    condition     = can([
      for float_ip in var.floating_ips : regex("\\w+", float_ip.home_location)
    ])
    error_message = "All floating IPs must have a valid 'home_location' attribute specified."
  }

  validation {
    condition     = can([
      for float_ip in var.floating_ips : regex("\\w+", float_ip.type)
    ])
    error_message = "All floating IPs must have a valid 'type' attribute specified."
  }
}
