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
  default     = "fmcv-7.3.0"
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