variable "hostname" {
  type        = string
  description = "The FQDN of the NSX-V Manager Appliance. DNS records must exist ahead of provisioning or DDNS must be working in the environment"
}

variable "folder_name" {
  type        = string
  description = "The name of the vm folder the NSX-V Manager Appliance should be created in."
}

variable "network_id" {
  type        = string
  description = "The ID of the network the NSX-V Manager Appliance should be attached to."
}

variable "datacenter_id" {
  type        = string
  description = "The ID of the dataceter the NSX-V Manager Appliance should be created in."
}

variable "resource_pool_id" {
  type        = string
  description = "The ID of the resource pool the NSX-V Manager Appliance should be created in."
}

variable "datastore_id" {
  type        = string
  description = "The ID of the datastore the NSX-V Manager Appliance should be created in."
}

variable "host_system_id" {
  type        = string
  description = "The ID of the host system that the NSX-V Manager Appliance OVA will be initially deployed on."
}

variable "cpu_count_override" {
  type        = number
  default     = 0
  description = "The number of CPUs the NSX-V Manager Appliance should have. Defaults to 0 which uses the CPU count of the OVF."

  validation {
    condition     = var.cpu_count_override >= 0
    error_message = "The cpu_count_override value must greater than or equal to 0."
  }
}

variable "memory_override" {
  type        = number
  default     = 0
  description = "The ammount of memory the NSX-V Manager Appliance should have. Defaults to 0 which uses the memory size of the OVF."

  validation {
    condition     = var.memory_override >= 0
    error_message = "The memory_override value must greater than or equal to 0."
  }
}

variable "enable_ssh" {
  type        = bool
  default     = true
  description = "Should SSH be enabled to the NSX-V Manager Appliance?"
}

variable "enable_ceip" {
  type        = bool
  default     = true
  description = "Should the Customer Experience Improvement Program (CEIP) be enabled for the NSX-V Manager Appliance?"
}

variable "ip_address" {
  type        = string
  default     = ""
  description = "The IP address of the NSX-V Manager Appliance. This defaults to \"\" which results in DHCP being used."
}

variable "mac_address" {
  type        = string
  default     = ""
  description = "The MAC address of the NSX-V Manager Appliance. This defaults to \"\" which results in a MAC address being generated."
}

variable "ova_path" {
  type        = string
  description = "The full path to the NSX-V Manager Appliance OVA."
}

variable "dns" {
  type        = string
  default     = ""
  description = "The DNS server for the NSX-V Manager Appliance. This defaults to \"\" which results in DHCP being used."
}

variable "ntp" {
  type        = string
  default     = "pool.ntp.org"
  description = "The NTP server for the NSX-V Manager Appliance."
}

variable "gateway" {
  type        = string
  default     = ""
  description = "The gateway of the NSX-V Manager Appliance. This defaults to \"\" which results in DHCP being used."
}

variable "netmask" {
  type        = string
  default     = ""
  description = "The netmask of the NSX-V Manager Appliance. This defaults to \"\" which results in DHCP being used."
}
