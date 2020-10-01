# ================================
# Example to manage FIPs with RDNS 
# ================================


# -------------
# Output Values
# -------------

output "floating_ips" {
  description = "A list of all floating IP objects."
  value       = module.floating_ip.floating_ips
}
