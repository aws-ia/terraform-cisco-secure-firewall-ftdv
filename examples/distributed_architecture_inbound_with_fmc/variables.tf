variable "aws_access_key" {
  type        = string
  description = "AWS ACCESS KEY"
  default     = ""
}

variable "aws_secret_key" {
  type        = string
  description = "AWS SECRET KEY"
  default     = ""
}
variable "region" {
  type        = string
  description = "AWS REGION"
  default     = "us-east-1"
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
  default     = "service-vpc-igw"
}

variable "mgmt_subnet_cidr" {
  description = "List out management Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.220.0/24", "172.16.210.0/24"]
}

variable "outside_subnet_cidr" {
  description = "List out outside Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.230.0/24", "172.16.241.0/24"]
}

variable "diag_subnet_cidr" {
  description = "List out diagonastic Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.24.0/24", "172.16.240.0/24"]
}

variable "inside_subnet_cidr" {
  description = "List out inside Subnet CIDR . "
  type        = list(string)
  default     = ["172.16.29.0/24", "172.16.190.0/24"]
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
      cidr_blocks = ["0.0.0.0/0"]
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
## Spoke  
########################################################################

variable "spoke_vpc_cidr" {
  type        = string
  description = "Specified CIDR for VPC . "
  default     = "10.6.0.0/16"
}

variable "spoke_vpc_name" {
  type        = string
  description = "Specified VPC Name . "
  default     = "dai-spoke-vpc"
}

variable "spoke_create_igw" {
  type        = bool
  description = " Condition to create IGW . "
  default     = true
}

variable "spoke_igw_name" {
  description = "name of existing IGW to be used"
  type        = string
  default     = ""
}

variable "spoke_subnet_cidr" {
  type        = list(string)
  description = "List out spoke Subnet CIDR . "
  default     = ["10.6.1.0/24", "10.6.2.0/24"]
}

variable "spoke_subnet_name" {
  type        = list(string)
  description = "List out spoke Subnet names . "
  default     = ["spoke1", "spoke2"]
}

variable "gwlbe_subnet_cidr" {
  type        = list(string)
  description = "List out GWLBE Subnet CIDR . "
  default     = ["10.6.10.0/24", "10.6.20.0/24"]
}

variable "gwlbe_subnet_name" {
  type        = list(string)
  description = "List out GWLBE Subnet names . "
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
  default     = "dai-GWLB"
}

variable "gwlb_tg_name" {
  type = string
  description = "GWLB target group name"
  default = "gwlb-tg"
}

variable "use_ftd_eip" {
  description = "boolean value to use EIP on FTD or not"
  type        = bool
  default     = true
}

variable "use_fmc_eip" {
  description = "boolean value to use EIP on FMC or not"
  type        = bool
  default     = false
}

variable "ftd_version" {
  type    = string
  default = "ftdv-7.2.7"
  description = "FTD version"
}

variable "fmc_version" {
  type    = string
  default = "fmcv-7.2.7"
  description = "FMC version"
}

variable "create_fmc" {
  description = "Boolean value to create FMC or not"
  type        = bool
  default     = true
}

variable "fmc_username" {
  type    = string
  default = "admin"
  description = "FMC username"
}

variable "fmc_password" {
  type    = string
  default = "Cisco@123"
  description = "FMC admin password"
}

variable "inbound" {
  type    = bool
  default = true
  description = "direction of traffic flow"
}

variable "service_vpc_cidr" {
  type        = string
  description = "Define CIDR to create a VPC"
  default     = ""
}

variable "inscount" {
  type    = number
  default = 2
  description = "FTD instance count"
}

variable "fmc_nat_id" {
  type    = string
  default = ""
  description = "NAT GW ID"
}

variable "fmc_insecure_skip_verify" {
  type    = bool
  default = true
  description = "Condition to verify fmc certificate"
}

variable "fmc_mgmt_interface" {
  type    = string
  default = ""
  description = "FMC mgmt interface id"
}

variable "ftd_mgmt_interface_ips" {
  type    = list(string)
  default = []
  description = "FTD mgmt interface IPs"
}

variable "fmc_host" {
  type    = string
  default = ""
  description = "FMC public ip"
}
