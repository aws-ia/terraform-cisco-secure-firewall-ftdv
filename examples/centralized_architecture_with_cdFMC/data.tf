data "template_file" "ftd_startup_file" {
  count    = var.inscount
  template = file("startup_file.txt")
  vars = {
    admin_password = var.ftd_admin_password
    ftd_hostname   = cdo_ftd_device.ftd[count.index].hostname
    fmc_reg_key    = cdo_ftd_device.ftd[count.index].reg_key
    fmc_nat_id     = cdo_ftd_device.ftd[count.index].nat_id
  }
}

data "aws_ami" "ftdv" {
  most_recent = true
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["${var.ftd_version}*"]
  }

  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}