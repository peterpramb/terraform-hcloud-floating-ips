# ================================
# Example to manage FIPs with RDNS 
# ================================


# ---------------------
# Environment Variables
# ---------------------

# Hetzner Cloud Project API Token
# HCLOUD_TOKEN="<api_token>"


# ---------------
# Input Variables
# ---------------

variable "dns_ptr" {
  description = "The DNS name the floating IP should resolve to."
  type        = string
  default     = "svc.example.net"
}

variable "host_num6" {
  description = "The host part of the IPv6 address to use."
  type        = string
  default     = "100"
}

variable "labels" {
  description = "The map of labels to be assigned to all managed resources."
  type        = map(string)
  default     = {
    "managed"    = "true"
    "managed_by" = "Terraform"
  }
}
