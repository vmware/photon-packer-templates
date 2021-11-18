/*
    DESCRIPTION:
    VMware Photon OS template.
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.7.8"
  required_plugins {
    vmware = {
      version = ">= v1.0.3"
      source  = "github.com/hashicorp/vmware"
    }
    virtualbox = {
      version = ">= v1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

//  BLOCK: source
//  Defines the builder configuration blocks.

source "vmware-iso" "vagrant-vmw" {
  display_name         = "${title(var.os_vendor)} ${title(var.os_distro)} OS ${var.os_version} ${upper(var.os_release)} ${title(var.os_packagelist)}"
  vm_name              = var.vm_name
  vmdk_name            = "${lower(var.vm_name)}-disk1"
  version              = var.hardware_version_vmw
  guest_os_type        = var.guest_os_vmw
  cpus                 = var.cpu_count
  memory               = var.memory_size
  network_adapter_type = var.network_adapter_vmw
  network              = var.network_vmw
  disk_adapter_type    = var.disk_adapter_vmw
  disk_size            = var.disk_size
  disk_type_id         = var.disk_type_vmw
  headless             = var.headless
  http_content = {
    "/ks.json" = templatefile("${abspath(path.root)}/photon.pkrtpl.hcl", {
      os_packagelist = var.os_packagelist
      ssh_username   = var.ssh_username
      ssh_password   = var.ssh_password
    })
  }
  iso_url           = var.iso_url
  iso_checksum      = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  boot_wait         = var.boot_wait
  boot_command      = var.boot_command
  boot_key_interval = var.boot_key_interval
  ssh_username      = var.ssh_username
  ssh_password      = var.ssh_password
  ssh_wait_timeout  = var.ssh_timeout
  shutdown_command  = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  vmx_data_post = {
    "usb.present" = "FALSE",
    "annotation"  = "Build Date: ${formatdate("YYYY-MM-DD", timestamp())}"
  }
}

source "virtualbox-iso" "vagrant-vbx" {
  vm_name                = var.vm_name
  guest_os_type          = var.guest_os_vbx
  guest_additions_path   = var.guest_additions_path
  guest_additions_url    = var.guest_additions_url
  guest_additions_sha256 = var.guest_additions_checksum
  cpus                   = var.cpu_count
  memory                 = var.memory_size
  disk_size              = var.disk_size
  hard_drive_interface   = var.disk_adapter_vbx
  gfx_controller         = var.gfx_controller_vbx
  gfx_vram_size          = var.gfx_memory_vbx
  headless               = var.headless
  http_content = {
    "/ks.json" = templatefile("${abspath(path.root)}/photon.pkrtpl.hcl", {
      os_packagelist = var.os_packagelist
      ssh_username   = var.ssh_username
      ssh_password   = var.ssh_password
    })
  }
  iso_url                = var.iso_url
  iso_checksum           = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  boot_wait              = var.boot_wait
  boot_command           = var.boot_command
  boot_keygroup_interval = var.boot_key_interval
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_wait_timeout       = var.ssh_timeout
  shutdown_command       = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
}

//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.

build {
  sources = ["source.vmware-iso.vagrant-vmw", "source.virtualbox-iso.vagrant-vbx"]

  provisioner "shell" {
    scripts = [
      "${path.cwd}/scripts/system/update-packages.sh",
      "${path.cwd}/scripts/system/install-packages.sh"
    ]
  }

  provisioner "shell" {
    script = "${path.cwd}/scripts/vagrant/setup-vagrant-user.sh"
    environment_vars = [
      "VAGRANT_USERNAME=${var.vagrant_username}",
      "VAGRANT_PASSWORD=${var.vagrant_password}",
      "VAGRANT_KEY=${var.vagrant_key}"
    ]
    pause_after       = "10s"
    expect_disconnect = true
  }

  provisioner "shell" {
    only   = ["vmware-iso.vagrant-vmw"]
    script = "${path.cwd}/scripts/vmware/install-vmw-guest-additions.sh"
  }

  provisioner "shell" {
    only   = ["virtualbox-iso.vagrant-vbx"]
    script = "${path.cwd}/scripts/virtualbox/install-vbx-guest-additions.sh"
  }

  provisioner "shell" {
    scripts = [
      "${path.cwd}/scripts/system/lockdown-security.sh",
      "${path.cwd}/scripts/system/complete-build.sh"
    ]
  }

  post-processors {

    post-processor "manifest" {
      output     = "${path.cwd}/output/manifest.json"
      strip_path = false
    }

    post-processor "vagrant" {
      only                 = ["vmware-iso.vagrant-vmw", "virtualbox-iso.vagrant-vbx"]
      keep_input_artifact  = false
      compression_level    = 9
      output               = "${path.cwd}/output/${lower(var.os_distro)}-${var.os_version}-${upper(var.os_release)}-${var.os_packagelist}-{{ .BuildName }}.box"
      vagrantfile_template = "${path.cwd}/scripts/vagrant/vagrantfile.tpl"
    }

  }
}