##################################################################################################################################
#Output
##################################################################################################################################

output "fmcv_eip" {
  value = aws_eip.fmc_mgmt_eip[*].public_ip
  description = "FMC public IP"
}

output "fmcv_ip" {
  value = aws_instance.fmcv[*].private_ip
  description = "FMC private IP"
}
