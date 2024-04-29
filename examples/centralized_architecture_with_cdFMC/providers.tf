terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
    fmc = {
      source = "CiscoDevNet/fmc"
      version = "1.4.8"
    }
    time = {
      source = "hashicorp/time"
      version = "0.10.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "fmc" {
is_cdfmc = true
cdo_token = var.token
fmc_host = var.fmc_host
cdfmc_domain_uuid = var.cdfmc_domain_uuid
fmc_insecure_skip_verify = var.fmc_insecure_skip_verify
}
