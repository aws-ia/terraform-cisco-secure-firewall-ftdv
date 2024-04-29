##################################################################################################################################
#Output
##################################################################################################################################

output "fmcv_eip" {
  value = aws_eip.fmc_mgmt_eip[*].public_ip
  description = "public ip of FMC"
}

output "fmcv_ip" {
  value = aws_instance.fmcv[*].private_ip
  description = "private ip of FMC"
}
