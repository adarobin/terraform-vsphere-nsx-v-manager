locals {
  split_hostname = split(".", var.hostname)
  short_hostname = local.split_hostname[0]
  domain         = join(".", slice(local.split_hostname, 1, length(local.split_hostname)))
}

resource "random_password" "admin_password" {
  length  = 16
  special = true
}

resource "random_password" "admin_enable_password" {
  length  = 16
  special = true
}

data "vsphere_ovf_vm_template" "ova" {
  name              = local.short_hostname
  folder            = var.folder_name
  resource_pool_id  = var.resource_pool_id
  datastore_id      = var.datastore_id
  host_system_id    = var.host_system_id
  local_ovf_path    = var.ova_path
  ovf_network_map   = { "Management Network" : var.network_id }
  ip_protocol       = "IPv4"
  disk_provisioning = "thin"
}

resource "vsphere_virtual_machine" "nsxv_manager" {
  name             = data.vsphere_ovf_vm_template.ova.name
  datacenter_id    = var.datacenter_id
  folder           = data.vsphere_ovf_vm_template.ova.folder
  resource_pool_id = data.vsphere_ovf_vm_template.ova.resource_pool_id
  host_system_id   = data.vsphere_ovf_vm_template.ova.host_system_id
  datastore_id     = data.vsphere_ovf_vm_template.ova.datastore_id

  num_cpus               = var.cpu_count_override > 0 ? var.cpu_count_override : data.vsphere_ovf_vm_template.ova.num_cpus
  num_cores_per_socket   = data.vsphere_ovf_vm_template.ova.num_cores_per_socket
  cpu_hot_add_enabled    = data.vsphere_ovf_vm_template.ova.cpu_hot_add_enabled
  cpu_hot_remove_enabled = data.vsphere_ovf_vm_template.ova.cpu_hot_remove_enabled
  nested_hv_enabled      = data.vsphere_ovf_vm_template.ova.nested_hv_enabled
  memory                 = var.memory_override > 0 ? var.memory_override : data.vsphere_ovf_vm_template.ova.memory
  memory_hot_add_enabled = data.vsphere_ovf_vm_template.ova.memory_hot_add_enabled
  annotation             = data.vsphere_ovf_vm_template.ova.annotation
  guest_id               = data.vsphere_ovf_vm_template.ova.guest_id
  alternate_guest_name   = data.vsphere_ovf_vm_template.ova.alternate_guest_name
  scsi_type              = data.vsphere_ovf_vm_template.ova.scsi_type
  scsi_controller_count  = data.vsphere_ovf_vm_template.ova.scsi_controller_count
  sata_controller_count  = data.vsphere_ovf_vm_template.ova.sata_controller_count
  ide_controller_count   = data.vsphere_ovf_vm_template.ova.ide_controller_count
  # swap_placement_policy  = data.vsphere_ovf_vm_template.ova.swap_placement_policy
  # firmware               = data.vsphere_ovf_vm_template.ova.firmware

  enable_logging = true

  network_interface {
    network_id     = var.network_id
    use_static_mac = var.mac_address == "" ? false : true
    mac_address    = var.mac_address
  }

  cdrom {}

  ovf_deploy {
    local_ovf_path    = data.vsphere_ovf_vm_template.ova.local_ovf_path
    disk_provisioning = data.vsphere_ovf_vm_template.ova.disk_provisioning
    ip_protocol       = data.vsphere_ovf_vm_template.ova.ip_protocol
    ovf_network_map   = data.vsphere_ovf_vm_template.ova.ovf_network_map
  }

  vapp {
    properties = {
      vsm_cli_passwd_0    = random_password.admin_password.result
      vsm_cli_en_passwd_0 = random_password.admin_enable_password.result
      vsm_hostname        = var.hostname
      vsm_ip_0            = var.ip_address
      vsm_netmask_0       = var.netmask
      vsm_gateway_0       = var.gateway
      vsm_dns1_0          = var.dns
      vsm_domain_0        = local.domain
      vsm_ntp_0           = var.ntp
      vsm_isSSHEnabled    = title(tostring(var.enable_ssh))
      vsm_isCEIPEnabled   = title(tostring(var.enable_ceip))

      # IPv6 stuff - not implemented
      #vsm_ipv6_0
      #vsm_prefix_ipv6_0
      #vsm_gateway_ipv6_0
    }
  }

  provisioner "local-exec" {
    command = "${path.module}/nsxv-wait-for-startup.sh"
    environment = {
      NSXV_MANAGER_HOSTNAME = var.hostname
      NSXV_USERNAME         = "admin"
      NSXV_PASSWORD         = random_password.admin_password.result
    }
  }

  lifecycle {
    ignore_changes = [
      // it looks like some of the properties get deleted from the VM after it is deployed
      // just ignore them after the initial deployment
      vapp.0.properties,
    ]
  }
}

data "tls_certificate" "nsxv_manager_certificate" {
  url          = "https://${var.hostname}"
  verify_chain = false

  depends_on = [
    vsphere_virtual_machine.nsxv_manager,
  ]
}
