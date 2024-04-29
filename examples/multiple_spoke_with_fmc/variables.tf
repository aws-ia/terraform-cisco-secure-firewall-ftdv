variable "aws_access_key" {
  type        = string
  description = "AWS ACCESS KEY"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS SECRET KEY"
}
variable "region" {
  type        = string
  description = "AWS REGION"
  default     = "us-east-1"
}

variable "service_vpc_cidr" {
  type        = string
  description = "Service VPC CIDR"
  default     = ""
}

variable "service_vpc_name" {
  type        = string
  description = "Service VPC Name"
  default     = "service-vpc"
}

variable "service_create_igw" {
  type        = bool
  description = "Boolean value to decide if to create IGW or not"
  default     = false
}

variable "service_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = "service-igw"
}

variable "mgmt_subnet_cidr" {
  description = "List out management Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.220.0/24", "172.16.210.0/24"]
}

variable "ftd_mgmt_ip" {
  description = "List out management IPs . "
  type        = list(string)
  default     = []
}

variable "outside_subnet_cidr" {
  description = "List out outside Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.230.0/24", "172.16.241.0/24"]
}

variable "ftd_outside_ip" {
  type        = list(string)
  description = "List outside IPs . "
  default     = []
}

variable "diag_subnet_cidr" {
  description = "List out diagonastic Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.24.0/24", "172.16.240.0/24"]
}

variable "ftd_diag_ip" {
  type        = list(string)
  description = "List out FTD Diagonostic IPs . "
  default     = []
}

variable "inside_subnet_cidr" {
  description = "List out inside Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.29.0/24", "172.16.190.0/24"]
}

variable "ftd_inside_ip" {
  description = "List FTD inside IPs . "
  type        = list(string)
  default     = []
}

variable "ftd_inside_gw" {
  description = "Inside subnet Gateway"
  type        = list(string)
  default     = ["172.16.29.1", "172.16.190.1"] 
}

variable "fmc_ip" {
  description = "List out FMCv IPs . "
  type        = string
  default     = ""
}

variable "fmc_host" {
  description = "FMC public IP"
  type = string
  default = ""
}

variable "tgw_subnet_cidr" {
  type        = list(string)
  description = "List of Transit GW Subnet CIDR"
  default     = []
}

variable "availability_zone_count" {
  type        = number
  description = "Spacified availablity zone count . "
  default     = 2
}

variable "mgmt_subnet_name" {
  type        = list(string)
  description = "Specified management subnet names"
  default     = ["mgmt1", "mgmt2"]
}

variable "outside_subnet_name" {
  type        = list(string)
  description = "Specified outside subnet names"
  default     = ["outside1", "outside2"]
}

variable "diag_subnet_name" {
  description = "Specified diagonstic subnet names"
  type        = list(string)
  default     = ["diag1", "diag2"]
}

variable "inside_subnet_name" {
  type        = list(string)
  description = "Specified inside subnet names"
  default     = ["inside1", "inside2"]
}

variable "tgw_subnet_name1" {
  type        = list(string)
  description = "List of name for TGW Subnets"
  default     = ["tgw1", "tgw2"]
}

variable "outside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 6081
      protocol    = "UDP"
      to_port     = 6081
      cidr_blocks = ["172.16.230.0/24", "172.16.241.0/24"]
      description = "GENEVE Access"
    },
    {
      from_port   = 22
      protocol    = "TCP"
      to_port     = 22
      cidr_blocks = ["172.16.230.0/24", "172.16.241.0/24"]
      description = "SSH Access"
    }
  ]
}

variable "inside_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      protocol    = "TCP"
      to_port     = 80
      cidr_blocks = ["172.16.29.0/24", "172.16.190.0/24"]
      description = "HTTP Access"
    }
  ]
}

variable "mgmt_interface_sg" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 8305
      protocol    = "TCP"
      to_port     = 8305
      cidr_blocks = ["172.16.220.0/24", "172.16.210.0/24", "172.16.0.0/24"]
      description = "Mgmt Traffic from FMC"
    }
  ]
}


variable "instances_per_az" {
  type        = number
  description = "Spacified no. of instance per az wants to be create . "
  default     = 1
}

########################################################################
## Spoke1 
########################################################################

variable "spoke1_vpc_cidr" {
  type        = string
  description = "Specified CIDR for VPC . "
  default     = "172.16.0.0/16"
}

variable "spoke1_vpc_name" {
  type        = string
  description = "Specified VPC Name . "
  default     = "spoke-vpc"
}

variable "spoke1_create_igw" {
  type        = bool
  description = " Condition to create IGW . "
  default     = true
}

variable "spoke1_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = "spoke-igw"
}

variable "spoke1_subnet_cidr" {
  type        = list(string)
  description = "List out spoke Subnet CIDR . "
  default     = ["172.16.1.0/24","172.16.2.0/24"]
}

variable "spoke1_subnet_name" {
  type        = list(string)
  description = "List out spoke Subnet names . "
  default     = ["web3", "web4"]
}

########################################################################
## Spoke2
########################################################################

variable "spoke2_vpc_cidr" {
  type        = string
  description = "Specified CIDR for VPC . "
  default     = "172.17.0.0/16"
}

variable "spoke2_vpc_name" {
  type        = string
  description = "Specified VPC Name . "
  default     = "spoke2-vpc"
}

variable "spoke2_create_igw" {
  type        = bool
  description = " Condition to create IGW . "
  default     = true
}

variable "spoke2_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = "spoke2-igw"
}

variable "spoke2_subnet_cidr" {
  type        = list(string)
  description = "List out spoke Subnet CIDR . "
  default     = ["172.17.1.0/24","172.17.2.0/24"]
}

variable "spoke2_subnet_name" {
  type        = list(string)
  description = "List out spoke Subnet names . "
  default     = ["db1", "db2"]
}

variable "gwlbe_subnet_cidr" {
  type        = list(string)
  description = "List out GWLBE Subnet CIDR . "
  default     = ["172.18.212.0/24", "172.18.232.0/24"]
}

variable "gwlbe_subnet_name" {
  type        = list(string)
  description = "List out GWLBE Subnet names . "
  default     = ["gwlb1", "gwlb2"]
}

variable "gwlb_tg_name" {
  type = string
  description = "GWLB Target group name"
  default = "gwlb-tg"
}

variable "ngw_subnet_cidr" {
  type        = list(string)
  description = "List out NGW Subnet CIDR . "
  default     = []
}

variable "ngw_subnet_name" {
  type        = list(string)
  description = "List out NGW Subnet names . "
  default     = []
}

########################################################################
## Instances
########################################################################

variable "ftd_size" {
  type        = string
  description = "FTD Instance Size"
  default     = "c5.xlarge"
}

variable "keyname" {
  type        = string
  description = "key to be used for the instances"
}

variable "block_encrypt" {
  description = "boolean value to encrypt block or not"
  default = false
  type = bool
}

########################################################################
## GatewayLoadbalncer 
########################################################################

variable "gwlb_name" {
  type        = string
  description = "name for Gateway loadbalancer"
  default = "GWLB"
}

variable "transit_gateway_name1" {
  type        = string
  description = "Name of the Transit Gateway created"
  default     = "tg-1"
}

variable "transit_gateway_name2" {
  type        = string
  description = "Name of the Transit Gateway created"
  default     = "tg-2"
}

variable "use_ftd_eip" {
  description = "boolean value to use EIP on FTD or not"
  type        = bool
  default     = false
}

variable "use_fmc_eip" {
  description = "boolean value to use EIP on FMC or not"
  type        = bool
  default     = false
}

variable "ftd_version" {
  default = "ftdv-7.3.0"
  type = string
  description = "FTD version"
}

variable "fmc_version" {
  default = "fmcv-7.3.0"
  type = string
  description = "FMC version"
}

variable "create_fmc" {
  description = "Boolean value to create FMC or not"
  type        = bool
  default     = false
}

variable "create_fmc_spoke1" {
  description = "Boolean value to create FMC or not"
  type        = bool
  default     = false
}

variable "create_fmc_spoke2" {
  description = "Boolean value to create FMC or not"
  type        = bool
  default     = false
}

variable "fmc_username" {
  type = string
  description = "FMC username"
  default = "admin"
}

variable "fmc_password" {
  type = string
  description = "FMC admin password"
  default = "Cisco@123"
}

variable "create_tgw1" {
  type = bool
  description = "condition to create transit gateway1"
  default = true
}

variable "create_tgw2" {
  type = bool
  description = "condition to create transit gateway2"
  default = false
}

variable "tgw_subnet_cidr1" {
  type    = list(string)
  description = "transit gateway subnet cidr"
  default = ["172.18.215.0/24", "172.18.225.0/24"]
}

variable "tgw_subnet_cidr2" {
  type    = list(string)
  description = "transit gateway subnet cidr"
  default = ["172.18.234.0/24", "172.18.235.0/24"]
}

variable "tgw_subnet_name2" {
  type    = list(string)
  description = "transit gateway subnet name"
  default = ["tgw21", "tgw22"]
}

variable "is_cdfmc" {
  type        = bool
  default     = false
  description = "Boolean value to decide if target fmc is cdfmc or not"
}

variable "token" {
  type        = string
  description = "CDO Access Token"
  default     = ""
}

variable "fmc_nat_id" {
  type        = string
  description = "FMC Registration NAT ID"
  default = "cisco"
}

variable "fmc_insecure_skip_verify" {
  type    = bool
  description = "Condition to verify FMC certificate"
  default = true
}

variable "inscount" {
  type    = number
  description = "FTD instance count"
  default = 2
}