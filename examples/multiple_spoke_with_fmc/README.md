<!-- BEGIN_TF_DOCS -->
# AWS GWLB Centralized Architecture setup with Cisco Secure Firewall in Multiple Spoke Environment

## Overview

Using this Terraform template following resources will be created:

### Service VPC
- Mgmt, Diag, Outside, Inside subnets per AZ
- One Gateway Load balancer
- 2 Cisco Secure Firewall Threat Defense (FTD) as GWLB Targets
- 1 TGW subnet per AZ
- Default route in TGW subnet route table to Gateway Load balancer Endpoint
- Gateway Load balancer Endpoint(GWLBE) subnets per AZ
- Spoke VPC 1 subnet route in GWLBE to Transit Gateway
- Spoke VPC 2 subnet route in GWLBE to Transit Gateway

### Spoke VPC 1
- 1 Spoke VPC with 2 subnets in different AZ

### Spoke VPC 2
- 1 Spoke VPC with 2 subnets in different AZ

### Transit Gateway
- One Transit Gateway
- Attachments for Transit Gateway to service and the 2 spoke vpc
- Transit Gateway Routing table for each attachements

### Terrform for FMC configuration
All the configuration on the Firewall Management Center are done by using the Cisco FMC Terraform Provider.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.7.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |
| <a name="CiscoDevNet/fmc"></a> [CiscoDevNet/fmc](#provider\_CiscoDevNet/fmc) | 1.4.8 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gwlb"></a> [gwlb](#module\_gwlb) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/gwlb | n/a |
| <a name="module_gwlbe"></a> [gwlbe](#module\_gwlbe) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/gwlbe | n/a |
| <a name="module_instance"></a> [instance](#module\_instance) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/firewall_instance | n/a |
| <a name="module_service_network"></a> [service\_network](#module\_service\_network) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/network | n/a |
| <a name="module_spoke_network1"></a> [spoke\_network1](#module\_spoke\_network1) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/network | n/a |
| <a name="module_spoke_network2"></a> [spoke\_network2](#module\_spoke\_network2) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/network | n/a |
| <a name="module_transitgateway1"></a> [transitgateway1](#module\_transitgateway1) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/transitgateway | n/a |
| <a name="module_transitgateway2"></a> [transitgateway2](#module\_transitgateway2) | /Users/sameersingh/git_repos/terraform-aws-secure-firewall/modules/transitgateway | n/a |

## Resources

| Name | Type |
|------|------|
| time_sleep.wait_for_ftd | resource |
| fmc_security_zone.inside | resource |
| fmc_security_zone.outside | resource |
| fmc_security_zone.vni | resource |
| fmc_host_objects.aws_meta | resource |
| fmc_host_objects.inside_gw | resource |
| fmc_smart_license.license | resource |
| fmc_access_policies.access_policy | resource |
| fmc_access_rules.access_rule_1 | resource |
| fmc_ftd_nat_policies.nat_policy | resource |
| fmc_ftd_manualnat_rules.new_rule | resource |
| fmc_devices.device1 | resource |
| fmc_devices.device2 | resource |
| fmc_device_physical_interfaces.physical_interfaces00 | resource |
| fmc_device_physical_interfaces.physical_interfaces01 | resource |
| fmc_staticIPv4_route.route | resource |
| fmc_policy_devices_assignments.policy_assignment | resource |
| fmc_device_vtep.vtep_policies | resource |
| fmc_device_vni.vni | resource |
| fmc_ftd_deploy.ftd | resource | 
| fmc_port_objects.http | data source |
| fmc_port_objects.ssh | data source |
| fmc_network_objects.any_ipv4 | data source |
| fmc_device_physical_interfaces.zero_physical_interface |  data source |
| fmc_device_physical_interfaces.one_physical_interface |  data source |
| fmc_devices.device | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Spacified availablity zone count . | `number` | `2` | no |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS ACCESS KEY | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS SECRET KEY | `string` | n/a | yes |
| <a name="input_create_fmc"></a> [create\_fmc](#input\_create\_fmc) | Boolean value to create FMC or not | `bool` | `true` | no |
| <a name="input_create_fmc_spoke1"></a> [create\_fmc\_spoke1](#input\_create\_fmc\_spoke1) | Boolean value to create FMC or not | `bool` | `true` | no |
| <a name="input_create_fmc_spoke2"></a> [create\_fmc\_spoke2](#input\_create\_fmc\_spoke2) | Boolean value to create FMC or not | `bool` | `true` | no |
| <a name="input_create_tgw1"></a> [create\_tgw1](#input\_create\_tgw1) | n/a | `bool` | n/a | yes |
| <a name="input_create_tgw2"></a> [create\_tgw2](#input\_create\_tgw2) | n/a | `bool` | n/a | yes |
| <a name="input_diag_subnet_cidr"></a> [diag\_subnet\_cidr](#input\_diag\_subnet\_cidr) | List out diagonastic Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_diag_subnet_name"></a> [diag\_subnet\_name](#input\_diag\_subnet\_name) | Specified diagonstic subnet names | `list(string)` | `[]` | no |
| <a name="input_domainUUID"></a> [domainUUID](#input\_domainUUID) | Domain UUID of the cdFMC | `string` | n/a | yes |
| <a name="input_fmc_ip"></a> [fmc\_ip](#input\_fmc\_ip) | List out FMCv IPs . | `string` | `""` | no |
| <a name="input_fmc_mgmt_interface_sg"></a> [fmc\_mgmt\_interface\_sg](#input\_fmc\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "FMC Mgmt Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_fmc_nat_id"></a> [fmc\_nat\_id](#input\_fmc\_nat\_id) | FMC Registration NAT ID | `string` | n/a | yes |
| <a name="input_fmc_password"></a> [fmc\_password](#input\_fmc\_password) | n/a | `string` | n/a | yes |
| <a name="input_fmc_username"></a> [fmc\_username](#input\_fmc\_username) | n/a | `string` | n/a | yes |
| <a name="input_fmc_version"></a> [fmc\_version](#input\_fmc\_version) | n/a | `string` | `"fmcv-7.3.0"` | no |
| <a name="input_ftd_diag_ip"></a> [ftd\_diag\_ip](#input\_ftd\_diag\_ip) | List out FTD Diagonostic IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_inside_gw"></a> [ftd\_inside\_gw](#input\_ftd\_inside\_gw) | Inside subnet Gateway | `list(string)` | n/a | yes |
| <a name="input_ftd_inside_ip"></a> [ftd\_inside\_ip](#input\_ftd\_inside\_ip) | List FTD inside IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_mgmt_ip"></a> [ftd\_mgmt\_ip](#input\_ftd\_mgmt\_ip) | List out management IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_outside_ip"></a> [ftd\_outside\_ip](#input\_ftd\_outside\_ip) | List outside IPs . | `list(string)` | `[]` | no |
| <a name="input_ftd_size"></a> [ftd\_size](#input\_ftd\_size) | FTD Instance Size | `string` | `"c5.xlarge"` | no |
| <a name="input_ftd_version"></a> [ftd\_version](#input\_ftd\_version) | n/a | `string` | `"ftdv-7.3.0"` | no |
| <a name="input_gwlb_name"></a> [gwlb\_name](#input\_gwlb\_name) | name for Gateway loadbalancer | `string` | n/a | yes |
| <a name="input_gwlbe_subnet_cidr"></a> [gwlbe\_subnet\_cidr](#input\_gwlbe\_subnet\_cidr) | List out GWLBE Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_gwlbe_subnet_name"></a> [gwlbe\_subnet\_name](#input\_gwlbe\_subnet\_name) | List out GWLBE Subnet names . | `list(string)` | `[]` | no |
| <a name="input_inside_interface_sg"></a> [inside\_interface\_sg](#input\_inside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Inside Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_inside_subnet_cidr"></a> [inside\_subnet\_cidr](#input\_inside\_subnet\_cidr) | List out inside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_inside_subnet_name"></a> [inside\_subnet\_name](#input\_inside\_subnet\_name) | Specified inside subnet names | `list(string)` | `[]` | no |
| <a name="input_instances_per_az"></a> [instances\_per\_az](#input\_instances\_per\_az) | Spacified no. of instance per az wants to be create . | `number` | `1` | no |
| <a name="input_is_cdfmc"></a> [is\_cdfmc](#input\_is\_cdfmc) | Boolean value to decide if target fmc is cdfmc or not | `bool` | `false` | no |
| <a name="input_keyname"></a> [keyname](#input\_keyname) | key to be used for the instances | `string` | n/a | yes |
| <a name="input_mgmt_interface_sg"></a> [mgmt\_interface\_sg](#input\_mgmt\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Mgmt Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_mgmt_subnet_cidr"></a> [mgmt\_subnet\_cidr](#input\_mgmt\_subnet\_cidr) | List out management Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_mgmt_subnet_name"></a> [mgmt\_subnet\_name](#input\_mgmt\_subnet\_name) | Specified management subnet names | `list(string)` | `[]` | no |
| <a name="input_ngw_subnet_cidr"></a> [ngw\_subnet\_cidr](#input\_ngw\_subnet\_cidr) | List out NGW Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_ngw_subnet_name"></a> [ngw\_subnet\_name](#input\_ngw\_subnet\_name) | List out NGW Subnet names . | `list(string)` | `[]` | no |
| <a name="input_outside_interface_sg"></a> [outside\_interface\_sg](#input\_outside\_interface\_sg) | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    cidr_blocks = list(string)<br>    description = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Outside Interface SG",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_outside_subnet_cidr"></a> [outside\_subnet\_cidr](#input\_outside\_subnet\_cidr) | List out outside Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_outside_subnet_name"></a> [outside\_subnet\_name](#input\_outside\_subnet\_name) | Specified outside subnet names | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS REGION | `string` | `"us-east-1"` | no |
| <a name="input_service_create_igw"></a> [service\_create\_igw](#input\_service\_create\_igw) | Boolean value to decide if to create IGW or not | `bool` | `false` | no |
| <a name="input_service_igw_name"></a> [service\_igw\_name](#input\_service\_igw\_name) | name of existing IGW to be used | `string` | `""` | no |
| <a name="input_service_vpc_cidr"></a> [service\_vpc\_cidr](#input\_service\_vpc\_cidr) | Service VPC CIDR | `string` | `null` | no |
| <a name="input_service_vpc_name"></a> [service\_vpc\_name](#input\_service\_vpc\_name) | Service VPC Name | `string` | `null` | no |
| <a name="input_spoke1_create_igw"></a> [spoke1\_create\_igw](#input\_spoke1\_create\_igw) | Condition to create IGW . | `bool` | `true` | no |
| <a name="input_spoke1_igw_name"></a> [spoke1\_igw\_name](#input\_spoke1\_igw\_name) | name of existing IGW to be used | `string` | `""` | no |
| <a name="input_spoke1_subnet_cidr"></a> [spoke1\_subnet\_cidr](#input\_spoke1\_subnet\_cidr) | List out spoke Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_spoke1_subnet_name"></a> [spoke1\_subnet\_name](#input\_spoke1\_subnet\_name) | List out spoke Subnet names . | `list(string)` | `[]` | no |
| <a name="input_spoke1_vpc_cidr"></a> [spoke1\_vpc\_cidr](#input\_spoke1\_vpc\_cidr) | Specified CIDR for VPC . | `string` | `null` | no |
| <a name="input_spoke1_vpc_name"></a> [spoke1\_vpc\_name](#input\_spoke1\_vpc\_name) | Specified VPC Name . | `string` | `null` | no |
| <a name="input_spoke2_create_igw"></a> [spoke2\_create\_igw](#input\_spoke2\_create\_igw) | Condition to create IGW . | `bool` | `true` | no |
| <a name="input_spoke2_igw_name"></a> [spoke2\_igw\_name](#input\_spoke2\_igw\_name) | name of existing IGW to be used | `string` | `""` | no |
| <a name="input_spoke2_subnet_cidr"></a> [spoke2\_subnet\_cidr](#input\_spoke2\_subnet\_cidr) | List out spoke Subnet CIDR . | `list(string)` | `[]` | no |
| <a name="input_spoke2_subnet_name"></a> [spoke2\_subnet\_name](#input\_spoke2\_subnet\_name) | List out spoke Subnet names . | `list(string)` | `[]` | no |
| <a name="input_spoke2_vpc_cidr"></a> [spoke2\_vpc\_cidr](#input\_spoke2\_vpc\_cidr) | Specified CIDR for VPC . | `string` | `null` | no |
| <a name="input_spoke2_vpc_name"></a> [spoke2\_vpc\_name](#input\_spoke2\_vpc\_name) | Specified VPC Name . | `string` | `null` | no |
| <a name="input_tgw_subnet_cidr"></a> [tgw\_subnet\_cidr](#input\_tgw\_subnet\_cidr) | List of Transit GW Subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_cidr1"></a> [tgw\_subnet\_cidr1](#input\_tgw\_subnet\_cidr1) | n/a | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_cidr2"></a> [tgw\_subnet\_cidr2](#input\_tgw\_subnet\_cidr2) | n/a | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_name1"></a> [tgw\_subnet\_name1](#input\_tgw\_subnet\_name1) | List of name for TGW Subnets | `list(string)` | `[]` | no |
| <a name="input_tgw_subnet_name2"></a> [tgw\_subnet\_name2](#input\_tgw\_subnet\_name2) | n/a | `list(string)` | `[]` | no |
| <a name="input_token"></a> [token](#input\_token) | CDO Access Token | `string` | `""` | no |
| <a name="input_transit_gateway_name1"></a> [transit\_gateway\_name1](#input\_transit\_gateway\_name1) | Name of the Transit Gateway created | `string` | `null` | no |
| <a name="input_transit_gateway_name2"></a> [transit\_gateway\_name2](#input\_transit\_gateway\_name2) | Name of the Transit Gateway created | `string` | `null` | no |
| <a name="input_use_fmc_eip"></a> [use\_fmc\_eip](#input\_use\_fmc\_eip) | boolean value to use EIP on FMC or not | `bool` | `false` | no |
| <a name="input_use_ftd_eip"></a> [use\_ftd\_eip](#input\_use\_ftd\_eip) | boolean value to use EIP on FTD or not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ip"></a> [instance\_ip](#output\_instance\_ip) | Public IP address of the FTD instances |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | Internet Gateway ID |
| <a name="output_fmc_mgmt_interface"></a> [fmc\_mgmt\_interface](#output\_fmc\_mgmt\_interface) | FMC Mgmt interface details |
| <a name="ftd_mgmt_interface_ips"></a> [ftd\_mgmt\_interface\_ips](#output\_ftd\_mgmt\_interface\_ips) | FTD mgmt interface details |

## Cleanup

To destroy the resources created on AWS and FMC run the following command
`terraform destroy`