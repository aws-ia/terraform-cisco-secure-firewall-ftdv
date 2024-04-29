##################################################################################################################################
#Output
##################################################################################################################################

output "fmcv_eip" {
  value = aws_eip.fmc-mgmt-eip[*].public_ip
  description = "FMC public ip"
}

output "fmcv_ip" {
  value = aws_instance.fmcv[*].private_ip
  description = "fmc private ip"
}
