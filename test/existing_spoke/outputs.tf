output "spoke_vpc" {
    description = "ID of the Spoke VPC"
    value = aws_vpc.spoke_vpc[0].id
}

output "spoke_igw" {
    description = "ID of the Spoke Internet GW"
    value = aws_internet_gateway.spoke_int_gw.id
}

output "spoke1" {
    description = "ID of the spoke1 subnet in spoke vpc"
    value = aws_subnet.spoke1.id
}

output "spoke2" {
    description = "ID of the spoke2 subnet in spoke vpc"
    value = aws_subnet.spoke2.id
}

output "fmcv_eip" {
  description = "Public IP of the FMC"
  value = aws_eip.fmc_mgmt_eip[*].public_ip
}

output "fmcv_ip" {
  description = "Private IP of the FMC"
  value = aws_instance.fmcv[*].private_ip
}