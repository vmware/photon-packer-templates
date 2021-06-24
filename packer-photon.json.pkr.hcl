variable "iso_file" {
  type    = string
  default = ""
}

variable "iso_sha1sum" {
  type    = string
  default = ""
}

variable "product_version" {
  type    = string
  default = ""
}

variable "root_password" {
  type    = string
  default = "2RQrZ83i79N6szpvZNX6"
}

variable "disk_size" {
  type    = number
  default = 20480
}

variable "memory_size" {
  type    = number
  default = 768
}

source "virtualbox-iso" "vagrant-virtualbox" {
  boot_command         = ["<esc><wait>", "vmlinuz initrd=initrd.img root=/dev/ram0 loglevel=3 ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/photon-kickstart.json insecure_installation=1 photon.media=cdrom", "<enter>"]
  boot_wait            = "5s"
  disk_size            = var.disk_size
  guest_os_type        = "Linux_64"
  hard_drive_interface = "scsi"
  headless             = false
  http_directory       = "scripts"
  iso_checksum         = "${var.iso_sha1sum}"
  iso_url              = "${var.iso_file}"
  memory               = var.memory_size
  shutdown_command     = "shutdown -h now"
  ssh_password         = "${var.root_password}"
  ssh_username         = "root"
  ssh_wait_timeout     = "60m"
  vm_name              = "photon"
}

source "vmware-iso" "vagrant-vmware" {
  boot_command         = ["<esc><wait>", "vmlinuz initrd=initrd.img root=/dev/ram0 loglevel=3 ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/photon-kickstart.json insecure_installation=1 photon.media=cdrom", "<enter>"]
  boot_key_interval    = "10ms"
  boot_wait            = "3s"
  disk_adapter_type    = "pvscsi"
  disk_size            = var.disk_size
  disk_type_id         = 0
  guest_os_type        = "other3xlinux-64"
  headless             = false
  http_directory       = "scripts"
  iso_checksum         = "${var.iso_sha1sum}"
  iso_url              = "${var.iso_file}"
  memory               = var.memory_size
  network_adapter_type = "vmxnet3"
  serial               = "FILE:serial.output"
  shutdown_command     = "shutdown -h now"
  ssh_password         = "${var.root_password}"
  ssh_username         = "root"
  ssh_wait_timeout     = "60m"
  version              = 11
  vm_name              = "photon"
  vmdk_name            = "photon-disk1"
  vmx_data_post = {
    displayname   = "VMware Photon"
    "usb.present" = "false"
  }
}

build {
  sources = ["source.virtualbox-iso.vagrant-virtualbox", "source.vmware-iso.vagrant-vmware"]

  provisioner "shell" {
    script = "scripts/photon-package_provisioning.sh"
  }

  provisioner "shell" {
    only   = ["vmware-iso.vagrant-vmware", "virtualbox-iso.vagrant-virtualbox"]
    script = "scripts/photon-vagrant-user_provisioning.sh"
  }

  provisioner "shell" {
    only   = ["vmware-iso.vagrant-vmware"]
    script = "scripts/photon-sharedfolders_prep.sh"
  }

  provisioner "shell" {
    only   = ["virtualbox-iso.vagrant-virtualbox"]
    script = "scripts/photon-vagrant-vbox_additions.sh"
  }

  provisioner "file" {
    destination = "/etc/modules-load.d/virtualbox.conf"
    only        = ["vmware-iso.vagrant-virtualbox"]
    source      = "scripts/photon-virtualbox-load-module.conf"
  }

  provisioner "shell" {
    inline = ["sed -i '/linux/ s/$/ net.ifnames=0/' /boot/grub2/grub.cfg"]
  }

  provisioner "shell" {
    inline = ["echo 'GRUB_CMDLINE_LINUX=\"net.ifnames=0\"' >> /etc/default/grub"]
  }

  provisioner "shell" {
    script = "scripts/photon-security_check.sh"
  }

  provisioner "shell" {
    inline = ["sed -i 's/OS/Linux/' /etc/photon-release"]
  }

  post-processor "vagrant" {
    compression_level    = 9
    only                 = ["vmware-iso.vagrant-vmware", "virtualbox-iso.vagrant-virtualbox"]
    output               = "photon-${var.product_version}-{{ .BuildName }}.box"
    vagrantfile_template = "scripts/photon-vagrantfile.rb"
  }
}
