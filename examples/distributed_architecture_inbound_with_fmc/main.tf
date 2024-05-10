module "service_network" {
  source = "CiscoDevNet/secure-firewall/aws//modules/network"
  vpc_name              = var.service_vpc_name
  vpc_cidr              = var.service_vpc_cidr
  create_fmc            = var.create_fmc
  create_igw            = var.service_create_igw
  igw_name              = var.service_igw_name
  mgmt_subnet_cidr      = var.mgmt_subnet_cidr
  outside_subnet_cidr   = var.outside_subnet_cidr
  diag_subnet_cidr      = var.diag_subnet_cidr
  inside_subnet_cidr    = var.inside_subnet_cidr
  fmc_ip                = var.fmc_ip
  mgmt_subnet_name      = var.mgmt_subnet_name
  outside_subnet_name   = var.outside_subnet_name
  diag_subnet_name      = var.diag_subnet_name
  inside_subnet_name    = var.inside_subnet_name
  outside_interface_sg  = var.outside_interface_sg
  inside_interface_sg   = var.inside_interface_sg
  mgmt_interface_sg     = var.mgmt_interface_sg
  fmc_mgmt_interface_sg = var.mgmt_interface_sg
  use_fmc_eip           = var.use_fmc_eip
  use_ftd_eip           = var.use_ftd_eip
}

module "spoke_network" {
  source = "CiscoDevNet/secure-firewall/aws//modules/network"
  vpc_name            = var.spoke_vpc_name
  vpc_cidr            = var.spoke_vpc_cidr
  create_igw          = var.spoke_create_igw
  igw_name            = var.spoke_igw_name
  create_fmc          = false
  outside_subnet_name = var.spoke_subnet_name
  outside_subnet_cidr = var.spoke_subnet_cidr
}

module "instance" {
  source = "CiscoDevNet/secure-firewall/aws//modules/firewall_instance"
  ftd_version             = var.ftd_version
  create_fmc              = var.create_fmc
  keyname                 = var.keyname
  ftd_size                = var.ftd_size
  instances_per_az        = var.instances_per_az
  availability_zone_count = var.availability_zone_count
  ftd_admin_password      = var.ftd_admin_password
  reg_key                 = var.reg_key
  fmc_mgmt_ip             = var.fmc_ip
  ftd_mgmt_interface      = module.service_network.mgmt_interface
  ftd_inside_interface    = module.service_network.inside_interface
  ftd_outside_interface   = module.service_network.outside_interface
  ftd_diag_interface      = module.service_network.diag_interface
  fmcmgmt_interface       = var.create_fmc ? module.service_network.fmcmgmt_interface : null
  block_encrypt           = var.block_encrypt
  fmc_nat_id              = var.fmc_nat_id
}

module "gwlb" {
  source = "CiscoDevNet/secure-firewall/aws//modules/gwlb"
  gwlb_name   = var.gwlb_name
  gwlb_tg_name = var.gwlb_tg_name
  gwlb_subnet = module.service_network.outside_subnet
  gwlb_vpc_id = module.service_network.vpc_id
  instance_ip = module.service_network.outside_interface_ip
}

module "gwlbe" {
  source = "CiscoDevNet/secure-firewall/aws//modules/gwlbe"
  gwlbe_subnet_cidr = var.gwlbe_subnet_cidr
  gwlbe_subnet_name = var.gwlbe_subnet_name
  vpc_id            = module.spoke_network.vpc_id
  gwlb             = module.gwlb.gwlb
  spoke_rt_id      = module.spoke_network.outside_rt_id
  inbound          = var.inbound
  internet_gateway = module.spoke_network.internet_gateway[0]
  spoke_subnet     = module.spoke_network.outside_subnet_cidr
}

#--------------------------------------------------------------------


################################################################################################
# Time Sleep blocks
################################################################################################

resource "time_sleep" "wait_for_ftd" {
  depends_on = [module.spoke_network, module.service_network, module.gwlb, module.gwlbe, module.instance]

  create_duration = "6m"
}


#--------------------------------------------------------------------
# FMC Configuration
#--------------------------------------------------------------------

################################################################################################
# Data blocks
################################################################################################
data "fmc_port_objects" "http" {
  name = "HTTP"
}
data "fmc_port_objects" "ssh" {
  name = "SSH"
}
data "fmc_network_objects" "any_ipv4" {
  name = "any-ipv4"
}
data "fmc_device_physical_interfaces" "zero_physical_interface" {
  count     = var.inscount
  device_id = data.fmc_devices.device[count.index].id
  name      = "TenGigabitEthernet0/0"
}
data "fmc_device_physical_interfaces" "one_physical_interface" {
  count     = var.inscount
  device_id = data.fmc_devices.device[count.index].id
  name      = "TenGigabitEthernet0/1"
}

################################################################################################
# Resource blocks
################################################################################################
resource "fmc_security_zone" "inside" {
  # depends_on     = [time_sleep.wait_600_seconds]
  depends_on     = [fmc_smart_license.license]
  name           = "inside"
  interface_mode = "ROUTED"
}
resource "fmc_security_zone" "outside" {
  # depends_on     = [time_sleep.wait_600_seconds]
  name           = "outside"
  interface_mode = "ROUTED"
}
resource "fmc_security_zone" "vni" {
  name           = "vni"
  interface_mode = "ROUTED"
}
resource "fmc_host_objects" "aws_meta" {
  name  = "aws_metadata_server"
  value = "169.254.169.254"
}
resource "fmc_host_objects" "inside_gw" {
  count = var.inscount
  name  = "inside-gateway${count.index + 1}"
  value = var.ftd_inside_gw[count.index]
}

resource "fmc_smart_license" "license" {
  registration_type = "EVALUATION"
}

resource "fmc_access_policies" "access_policy" {
  name                              = "GWLB-ACP"
  default_action                    = "BLOCK"
  default_action_send_events_to_fmc = "true"
  default_action_log_end            = "true"
}

resource "fmc_access_rules" "access_rule_1" {
  count   = var.block_encrypt ? 0 : 1
  acp     = fmc_access_policies.access_policy.id
  section = "mandatory"
  name    = "Rule-1"
  action  = "allow"
  enabled = true
  # syslog_severity = "alert"
  # enable_syslog = true
  send_events_to_fmc = true
  log_end            = true
  destination_networks {
    destination_network {
      id   = fmc_host_objects.aws_meta.id
      type = fmc_host_objects.aws_meta.type
    }
  }
  destination_ports {
    destination_port {
      id   = data.fmc_port_objects.http.id
      type = data.fmc_port_objects.http.type
    }
  }
  new_comments = ["Testing via terraform"]
}

resource "fmc_ftd_nat_policies" "nat_policy" {
  count       = var.block_encrypt ? 0 : var.inscount
  name        = "NAT_Policy${count.index}"
  description = "Nat policy by terraform"
}

resource "fmc_ftd_manualnat_rules" "new_rule" {
  count      = var.block_encrypt ? 0 : var.inscount
  nat_policy = fmc_ftd_nat_policies.nat_policy[count.index].id
  nat_type   = "static"
  original_source {
    id   = data.fmc_network_objects.any_ipv4.id
    type = data.fmc_network_objects.any_ipv4.type
  }
  source_interface {
    id   = fmc_security_zone.outside.id
    type = "SecurityZone"
  }
  destination_interface {
    id   = fmc_security_zone.inside.id
    type = "SecurityZone"
  }
  original_destination_port {
    id   = data.fmc_port_objects.ssh.id
    type = data.fmc_port_objects.ssh.type
  }
  translated_destination_port {
    id   = data.fmc_port_objects.http.id
    type = data.fmc_port_objects.http.type
  }
  translated_destination {
    id   = fmc_host_objects.aws_meta.id
    type = fmc_host_objects.aws_meta.type
  }
  interface_in_original_destination = true
  interface_in_translated_source    = true
}

resource "fmc_devices" "device1" {
  depends_on   = [time_sleep.wait_for_ftd, fmc_ftd_nat_policies.nat_policy, fmc_security_zone.inside, fmc_security_zone.outside,fmc_smart_license.license]
  name         = "FTD1"
  hostname     = module.service_network.mgmt_interface_ip[0]
  regkey       = "cisco"
  license_caps = ["MALWARE"]
  nat_id       = var.fmc_nat_id
  access_policy {
    id   = fmc_access_policies.access_policy.id
    type = fmc_access_policies.access_policy.type
  }
}
resource "fmc_devices" "device2" {
  depends_on   = [fmc_smart_license.license, fmc_devices.device1]
  name         = "FTD2"
  hostname     = module.service_network.mgmt_interface_ip[1]
  regkey       = "cisco"
  license_caps = ["MALWARE"]
  nat_id       = var.fmc_nat_id
  access_policy {
    id   = fmc_access_policies.access_policy.id
    type = fmc_access_policies.access_policy.type
  }
}
##############################
#Intermediate data block for devices
##############################
data "fmc_devices" "device" {
  depends_on = [fmc_devices.device2]
  count      = var.inscount
  name       = "FTD${count.index + 1}"
}
##############################
resource "fmc_device_physical_interfaces" "physical_interfaces00" {
  count                  = var.inscount
  enabled                = true
  device_id              = data.fmc_devices.device[count.index].id
  physical_interface_id  = data.fmc_device_physical_interfaces.zero_physical_interface[count.index].id
  name                   = data.fmc_device_physical_interfaces.zero_physical_interface[count.index].name
  security_zone_id       = fmc_security_zone.outside.id
  if_name                = "outside"
  description            = "Applied by terraform"
  mtu                    = 1900
  mode                   = "NONE"
  ipv4_dhcp_enabled      = true
  ipv4_dhcp_route_metric = 1
}
resource "fmc_device_physical_interfaces" "physical_interfaces01" {
  count                  = var.inscount
  device_id              = data.fmc_devices.device[count.index].id
  physical_interface_id  = data.fmc_device_physical_interfaces.one_physical_interface[count.index].id
  name                   = data.fmc_device_physical_interfaces.one_physical_interface[count.index].name
  security_zone_id       = fmc_security_zone.inside.id
  if_name                = "inside"
  description            = "Applied by terraform"
  mtu                    = 1900
  mode                   = "NONE"
  ipv4_dhcp_enabled      = true
  ipv4_dhcp_route_metric = 1
}

resource "fmc_staticIPv4_route" "route" {
  depends_on     = [data.fmc_devices.device, fmc_device_physical_interfaces.physical_interfaces00, fmc_device_physical_interfaces.physical_interfaces01]
  count          = var.inscount
  metric_value   = 25
  device_id      = data.fmc_devices.device[count.index].id
  interface_name = "inside"
  selected_networks {
    id   = fmc_host_objects.aws_meta.id
    type = fmc_host_objects.aws_meta.type
    name = fmc_host_objects.aws_meta.name
  }
  gateway {
    object {
      id   = fmc_host_objects.inside_gw[count.index].id
      type = fmc_host_objects.inside_gw[count.index].type
      name = fmc_host_objects.inside_gw[count.index].name
    }
  }
}

resource "fmc_policy_devices_assignments" "policy_assignment" {
  depends_on = [fmc_staticIPv4_route.route]
  count      = var.block_encrypt ? 0 : var.inscount
  policy {
    id   = fmc_ftd_nat_policies.nat_policy[count.index].id
    type = fmc_ftd_nat_policies.nat_policy[count.index].type
  }
  target_devices {
    id   = data.fmc_devices.device[count.index].id
    type = data.fmc_devices.device[count.index].type
  }
}

resource "fmc_device_vtep" "vtep_policies" {
  depends_on  = [fmc_staticIPv4_route.route]
  count       = var.inscount
  device_id   = data.fmc_devices.device[count.index].id
  nve_enabled = true

  nve_vtep_id            = 1
  nve_encapsulation_type = "GENEVE"
  nve_destination_port   = 6081
  source_interface_id    = data.fmc_device_physical_interfaces.zero_physical_interface[count.index].id
}
resource "fmc_device_vni" "vni" {
  depends_on       = [fmc_device_vtep.vtep_policies]
  count            = var.inscount
  device_id        = data.fmc_devices.device[count.index].id
  if_name          = "vni${count.index + 1}"
  description      = "Applied via terraform"
  security_zone_id = fmc_security_zone.outside.id
  vnid             = count.index + 1
  enable_proxy     = true
  enabled          = true
  vtep_id          = 1
}

resource "fmc_ftd_deploy" "ftd" {
  depends_on     = [fmc_device_vni.vni, fmc_device_vtep.vtep_policies, fmc_policy_devices_assignments.policy_assignment]
  count          = var.inscount
  device         = data.fmc_devices.device[count.index].id
  ignore_warning = true
  force_deploy   = false
}
