#####################################################################################################################
# Variables 
#####################################################################################################################

variable "aws_access_key" {
  description = "AWS Access Key"
  type = string
}
variable "aws_secret_key" {
  description = "AWS Secret key"
  type = string
}

variable "region" {
  description = "AWS Region"
  type = string
  default = "eu-central-1"
}

variable "azs" {
  default     = []
  type = list(string)
  description = "AWS Availability Zones"
}

variable "name_tag_prefix" {
  default     = "FMCv"
  type = string
  description = "Prefix for the 'Name' tag of the resources"
}

variable "instances" {
  default     = 1
  type = number
  description = "Number of FMCv instances"
}

variable "fmc_version" {
  default     = "fmcv-7.2.7"
  type = string
  description = "Version of the FMCv"
}

variable "fmc_size" {
  default     = "c5.4xlarge"
  type = string
  description = "Size of the FMCv instance"
}

variable "vpc_name" {
  default     = "Cisco-FMCv"
  type = string
  description = "VPC Name"
}

variable "service_vpc_igw_name" {
  type = string
  description = "service VPC IGW name"
  default = "service-vpc-igw"
}

variable "vpc_id" {
  default     = ""
  description = "Existing VPC ID"
  type = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
  type = string
}

variable "subnet_size" {
  default     = 24
  description = "Size of Management subnet"
  type = number
}

variable "igw_id" {
  default     = ""
  description = "Existing Internet Gateway ID"
  type = string
}

variable "password" {
  default     = "Cisco@123"
  description = "Password for FMCv"
  sensitive   = true
  type = string
}

variable "hostname" {
  default     = "fmc"
  description = "FMCv OS hostname"
  type = string
}

variable "keyname" {
  description = "AWS EC2 Key"
  default = "ln"
  type = string
}

variable "subnets" {
  default     = ["10.0.0.0/24"]
  description = "mgmt subnets"
  type = list(string)
}

variable "spoke1_vpc_name" {
  type = string
  description = "Name of Spoke1 VPC"
  default = "spoke1"
}

variable "spoke1_vpc_cidr" {
  type = string
  description = "Spoke1 VPC CIDR"
  default = "172.16.0.0/16"
}

variable "spoke2_vpc_name" {
  type = string
  description = "Name of Spoke2 VPC"
  default = "spoke2"
}

variable "spoke2_vpc_cidr" {
  type = string
  description = "Spoke1 VPC CIDR"
  default = "172.17.0.0/16"
}

variable "spoke1_igw_name" {
  type = string
  description = "Spoke1 VPC IGW Name"
  default = "spoke1_igw"
}

variable "spoke2_igw_name" {
  type = string
  description = "Spoke2 VPC IGW Name"
  default = "spoke2_igw"
}

variable "spoke_instances" {
  default = 2
  type = number
  description = "Number of instances in spoke vpc"
}

variable "spoke1_subnet_name" {
  type = list(string)
  description = "Subnet names in spoke1 VPC"
  default = ["web1","web2"]
}

variable "spoke1_subnet_cidr" {
  type = list(string)
  description = "subnet cidr in spoke1 VPC"
  default = ["172.16.1.0/24","172.16.2.0/24"]
}

variable "spoke2_subnet_name" {
  type = list(string)
  description = "Subnet names in spoke2 VPC"
  default = ["db1","db2"]
}

variable "spoke2_subnet_cidr" {
  type = list(string)
  description = "subnet cidr in spoke2 VPC"
  default = ["172.17.1.0/24","172.17.2.0/24"]
}
