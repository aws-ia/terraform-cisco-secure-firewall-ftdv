output "instance_ip" {
  description = "Public IP address of the FTD instances"
  value       = module.instance.instance_private_ip
}

output "internet_gateway" {
  description = "Internet Gateway ID"
  value       = module.service_network.internet_gateway
}

output "fmc_mgmt_interface" {
  description = "FMC mgmt interface details"
  value = module.service_network.fmcmgmt_interface
}

output "ftd_mgmt_interface_ips" {
  description = "FTD mgmt interface details"
  value = module.service_network.mgmt_interface_ip
}