locals {
  azs             = length(var.azs) > 0 ? var.azs : data.aws_availability_zones.available[0].names
  az_distribution = chunklist(sort(flatten(chunklist(setproduct(range(var.instances), local.azs), var.instances)[0])), var.instances)[1]
  az_distinct     = distinct(local.az_distribution)
  spoke_az_distribution = chunklist(sort(flatten(chunklist(setproduct(range(var.spoke_instances), local.azs), var.spoke_instances)[0])), var.spoke_instances)[1]
  spoke_az_distinct     = distinct(local.spoke_az_distribution)
  vpc_cidr        = var.vpc_id != "" ? data.aws_vpc.selected[0].cidr_block : var.vpc_cidr
  subnet_newbits  = var.subnet_size - tonumber(split("/", local.vpc_cidr)[1])
}