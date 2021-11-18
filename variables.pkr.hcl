/*
    DESCRIPTION:
    VMware Photon OS template.
*/

variable "os_vendor" {
  type    = string
  default = "VMware"
}

variable "os_distro" {
  type    = string
  default = "Photon"
}

variable "os_version" {
  type = string
}

variable "os_release" {
  type = string
}

variable "os_packagelist" {
  type        = string
  description = "The VMware Photon OS installation package."
  default     = "minimal"
  validation {
    condition     = contains(["minimal", "developer"], var.os_packagelist)
    error_message = "Must be one of 'minimal' or 'developer'."
  }
}

variable "vm_name" {
  type    = string
  default = "photon"
}

variable "iso_url" {
  type = string
}

variable "iso_checksum_type" {
  type    = string
  default = "sha1"
  validation {
    condition     = contains(["sha1", "md5"], var.iso_checksum_type)
    error_message = "Must be one of 'sha1' or 'md5'."
  }
}

variable "iso_checksum_value" {
  type = string
}

variable "guest_additions_path" {
  type    = string
  default = "/root/VBoxGuestAdditions.iso"
}

variable "guest_additions_url" {
  type = string
}

variable "guest_additions_checksum" {
  type = string
}

variable "boot_wait" {
  type    = string
  default = "3s"
}

variable "boot_key_interval" {
  type    = string
  default = "10ms"
}

variable "boot_command" {
  type = list(string)
  default = [
    "<esc><wait>",
    "vmlinuz initrd=initrd.img root=/dev/ram0 loglevel=3 ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.json insecure_installation=1 photon.media=cdrom",
    "<enter>"
  ]
}

variable "ssh_timeout" {
  type    = string
  default = "15m"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_password" {
  type      = string
  default   = "VMw@re123!"
  sensitive = true
}

variable "vagrant_username" {
  type    = string
  default = "vagrant"
}

variable "vagrant_password" {
  type      = string
  default   = "VMw@re123!"
  sensitive = true
}

variable "vagrant_key" {
  type      = string
  default   = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
  sensitive = true
}

variable "headless" {
  type    = bool
  default = false
}

variable "hardware_version_vmw" {
  type    = number
  default = 18
  validation {
    condition = (
      var.hardware_version_vmw >= 11 &&
      var.hardware_version_vmw <= 18
    )
    error_message = "Must be between 11 and 18."
  }
}

variable "guest_os_vmw" {
  type    = string
  default = "vmware-photon-64"
}

variable "guest_os_vbx" {
  type    = string
  default = "Linux_64"
}

variable "cpu_count" {
  type    = number
  default = 2
}

variable "memory_size" {
  type    = number
  default = 1024
}

variable "disk_adapter_vmw" {
  type    = string
  default = "pvscsi"
}

variable "disk_adapter_vbx" {
  type    = string
  default = "scsi"
}

variable "disk_type_vmw" {
  type    = number
  default = 0
  validation {
    condition = (
      var.disk_type_vmw >= 0 &&
      var.disk_type_vmw <= 5
    )
    error_message = "Must be between 0 and 5."
  }
}

variable "disk_size" {
  type    = number
  default = 20480
}

variable "gfx_controller_vbx" {
  type    = string
  default = "vboxsvga"
}

variable "gfx_memory_vbx" {
  type    = string
  default = "128"
}

variable "network_adapter_vmw" {
  type    = string
  default = "vmxnet3"
}

variable "network_vmw" {
  type    = string
  default = "nat"
  validation {
    condition     = contains(["nat", "bridged", "hostonly"], var.network_vmw)
    error_message = "Must be one of 'nat', 'bridged', or 'hostonly'."
  }
}