# NSX-V Manager Terraform Module

Terraform module which creates an NSX-V Manager virtual machine in a vSphere environment.

Presently, this module does not work with the official `terraform-provider-vsphere`. You must compile the provider from
[#1339](https://github.com/hashicorp/terraform-provider-vsphere/pull/1339).

The module presently assumes you are deploying from a machine with `bash` and `curl` installed.

The module has been tested with `VMware-NSX-Manager-6.4.10-17626462.ova`.
Other versions may or may not work correctly.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| random | n/a |
| tls | n/a |
| vsphere | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |
| [tls_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) |
| [vsphere_ovf_vm_template](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/ovf_vm_template) |
| [vsphere_virtual_machine](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cpu\_count\_override | The number of CPUs the NSX-V Manager Appliance should have. Defaults to 0 which uses the CPU count of the OVF. | `number` | `0` | no |
| datacenter\_id | The ID of the dataceter the NSX-V Manager Appliance should be created in. | `string` | n/a | yes |
| datastore\_id | The ID of the datastore the NSX-V Manager Appliance should be created in. | `string` | n/a | yes |
| dns | The DNS server for the NSX-V Manager Appliance. This defaults to "" which results in DHCP being used. | `string` | `""` | no |
| enable\_ceip | Should the Customer Experience Improvement Program (CEIP) be enabled for the NSX-V Manager Appliance? | `bool` | `true` | no |
| enable\_ssh | Should SSH be enabled to the NSX-V Manager Appliance? | `bool` | `true` | no |
| folder\_name | The name of the vm folder the NSX-V Manager Appliance should be created in. | `string` | n/a | yes |
| gateway | The gateway of the NSX-V Manager Appliance. This defaults to "" which results in DHCP being used. | `string` | `""` | no |
| host\_system\_id | The ID of the host system that the NSX-V Manager Appliance OVA will be initially deployed on. | `string` | n/a | yes |
| hostname | The FQDN of the NSX-V Manager Appliance. DNS records must exist ahead of provisioning or DDNS must be working in the environment | `string` | n/a | yes |
| ip\_address | The IP address of the NSX-V Manager Appliance. This defaults to "" which results in DHCP being used. | `string` | `""` | no |
| mac\_address | The MAC address of the NSX-V Manager Appliance. This defaults to "" which results in a MAC address being generated. | `string` | `""` | no |
| memory\_override | The ammount of memory the NSX-V Manager Appliance should have. Defaults to 0 which uses the memory size of the OVF. | `number` | `0` | no |
| netmask | The netmask of the NSX-V Manager Appliance. This defaults to "" which results in DHCP being used. | `string` | `""` | no |
| network\_id | The ID of the network the NSX-V Manager Appliance should be attached to. | `string` | n/a | yes |
| ntp | The NTP server for the NSX-V Manager Appliance. | `string` | `"pool.ntp.org"` | no |
| ova\_path | The full path to the NSX-V Manager Appliance OVA. | `string` | n/a | yes |
| resource\_pool\_id | The ID of the resource pool the NSX-V Manager Appliance should be created in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| admin\_enable\_password | n/a |
| admin\_password | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->