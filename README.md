![VMware Photon OS][vmware-photon-logo]

# Packer Templates for VMware Photon OS

<img alt="VMware Fusion" src="https://img.shields.io/badge/VMware%20Fusion-12-blue?style=for-the-badge"> <img alt="VMware Workstation Pro" src="https://img.shields.io/badge/VMware%20Workstation%20Pro-16-blue?style=for-the-badge"> <img alt="VirtualBox" src="https://img.shields.io/badge/VirtualBox-6.1-blue?style=for-the-badge"><br/>
<img alt="Packer" src="https://img.shields.io/badge/Packer-1.8.3+-blue?style=for-the-badge&logo=packer">
<img alt="Vagrant" src="https://img.shields.io/badge/Vagrant-2.3.1+-blue?style=for-the-badge&logo=vagrant">

## Introduction

This repository provides infrastructure-as-code examples to automate the creation of [VMware Photon OS][vmware-photon] ( `x86_64` ) machine images as Vagrant boxes using Packer. These Vagrant boxes can be run on VMware Fusion, VMware Workstation Pro, and VirtualBox.

This project is also used to generate the offical [`vmware/photon`][vagrant-boxes-photon] Vagrant boxes.

All examples are authored in the HashiCorp Configuration Language ("HCL2").

The following builds are available:

* VMware Photon OS 4.0 R2 (default)
* VMware Photon OS 4.0 R1
* VMware Photon OS 3.0 R3

## Requirements

* [HashiCorp Packer][packer] 1.8.3 or later
  * Packer Plugin for VMware ( `vmware-iso` ) 1.0.7 or later
  * Packer Plugin for Virtualbox ( `virtualbox-iso` ) 1.0.4 or later (Optional)

      > Required Packer plugins are automatically downloaded and initialized when using the `Makefile`.
      >
      > For dark sites, you may download the plugins and place these same directory as your Packer executable `/usr/local/bin` or `$HOME/.packer.d/plugins`.

* [HashiCorp Vagrant][vagrant-download] 2.3.1 or later

  * Vagrant Plugin for VMware ( `vagrant-vmware-desktop` ) 3.0.1 or later
  * Vagrant [VMware Utility][vagrant-vmware-utility] 1.0.21 or later

* [VMware Fusion][vmware-fusion] 12 (macOS) or [VMware Workstation Pro][vmware-workstation] 16 (Windows and Linux)

* [Virtualbox][virtualbox] 6.1 (Optional)

The following software packages are recommened to be installed on the Packer host:

* Git

  Used for cloning the project repository.For information on installing the Git Command line tools, see [Git][git].

* Microsoft Visual Code
  
  Used for editing configrations. For information on installing Microsoft Visual Studio Code, see [Visual Studio Code][vscode].
  
  The Visual Studio Code extension for Packer 0.3.0 or later is also recommended for syntax support. Learn more on the [Visual Studio Code Marketplace][vscode-packer].

## Get Started

### Step 1 - Clone the Repository

Clone the project repository.

  **Example**:

  ```console
  git clone https://github.com/vmware/photon-packer-templates.git
  ```

  The general directory structure of the repository.

  ```console
  ├── scripts
  │   ├── system
  │   │   └── *.sh
  │   ├── vagrant
  │   │   ├── *.sh
  │   │   └── *.tpl
  │   ├── virtualbox
  │   │   └── *.sh
  │   ├── vmware
  │   │   └── *.sh*
  │   └── *.sh
  ├── output
  │   ├── photon-<version>-<release>-vagrant-<provider>.box
  │   └── manifest.json
  ├── LICENSE
  ├── Makefile
  ├── NOTICE
  ├── override.pkrvars.hcl
  ├── photon-<version>-<release>.pkrvars.hcl
  ├── photon.pkr.hcl
  ├── photon.pkrtpl.hcl
  ├── README.md
  └── variables.pkr.hcl
  ```

  The files are distributed in the following directories.
  
* **`output`** - location of the Vagrant boxes and manifest created after the completion of the machine image build.

* **`scripts`** - contains the scripts to initialize and prepare the machine image builds based on the platform for the Vagrant box.

### Step 2 - Update Input Variables

1. Obtain the URL, checksum type (_e.g._, `sha1`), and checksum value for the VMware Photon OS `.iso` image. This will be use in the build input variables.

1. Obtain the `sha256` checksum value for the VirtualBox Guest Additions `.iso` image. This will be use as input variables when building for VirtualBox.

1. Update the contents of the `photon-<version>-<release>.pkrvars.hcl` file, as needed.

  ```hcl
  // VMware Photon OS Settings

  os_version         = "4.0"
  os_release         = "R2"
  iso_checksum_type  = "sha1"
  iso_checksum_value = "eeb08738209bf77306268d63b834fd91f6cecdfb"
  iso_url            = "https://packages.vmware.com/photon/4.0/Rev2/iso/photon-4.0-c001795b8.iso"

  // VirtualBox Guest Additions

  guest_additions_url      = "https://download.virtualbox.org/virtualbox/6.1.40/VBoxGuestAdditions_6.1.40.iso"
  guest_additions_checksum = "d456c559926f1a8fdd7259056e0a50f12339fd494122cf30db7736e2032970c6"
  ```

1. Modify the Overrides (Optional)

  The project sets input defaults in the `variables.pkr.hcl`. You can override the defaults by editing the `override.pkr.hcl` file and uncommenting the relevent overrides.

  ```hcl
  # Override the default input variable values.

  # os_packagelist           = "minimal"
  # vm_name                  = "photon"
  # guest_additions_url      = "https://download.virtualbox.org/virtualbox/7.0.0/VBoxGuestAdditions_7.0.0.iso"
  # guest_additions_checksum = "f1e214507e4e845e18fdc4ce6ae9ab3aa3514f37d8a702201129c69ea2b3a675"
  # ssh_password             = "VMw@re123!"
  # ssh_timeout              = "15m"
  # boot_wait                = "3s"
  # boot_key_interval        = "10ms"
  # hardware_version_vmw     = 18
  # headless                 = false
  # cpu_count                = 2
  # memory_size              = 1024
  # disk_size                = 20480
  # network_vmw              = nat
  ```

## Build

You can use the included `Makefile` to validate and build the all or specific machine images on macOS and Linux:

```shell
> make

Targets:
  validate
    validate-vmware-iso.vagrant-vmw
    validate-virtualbox-iso.vagrant-vbx
   
  build
    build-vmware-iso.vagrant-vmw
    build-virtualbox-iso.vagrant-vbx
   
  clean
```

* **`validate`** - validates the configuration for all or specific targets.

* **`build`** - runs a build for all or specific targets.

* **`clean`** - removes all artifacts from the the `output` directory **and** removes the `packer_cache` directory. It **does not** remove any registered Vagrant boxes.

All required Packer plugins are automatically initialized when using validate and build options. If the plugins are not present, they will be automatically downloaded and installed.

For dark sites, you may download the plugins and place these same directory as your Packer executable `/usr/local/bin` or `$HOME/.packer.d/plugins`.

**Example**: Build all targets.

```shell
make build 
```

**Example**: Build only the VMware Fusion / Workstation Pro target.

```shell
make build-vmware-iso.vagrant-vmw
```

Alternatively, you can manually initilize, validate, and build on macOS, Linux, and Windows.

**Example**: Initialize for all targets.

* macOS and Linux:

  ```shell
  packer init -var-file=photon-4.0-R2.pkrvars.hcl .
  ```

* Windows:

  ```powershell
  packer init -var-file .\photon-4.0-R2.pkrvars.hcl .
  ```

**Example**: Validate all targets.

* macOS and Linux:

  ```shell
  packer validate -var-file=photon-4.0-R2.pkrvars.hcl .
  ```

* Windows:

  ```powershell
  packer validate -var-file .\photon-4.0-R2.pkrvars.hcl .
  ```

**Example**: Build all targets.

* macOS and Linux:

  ```shell
  packer build --force -var-file=photon-4.0-R2.pkrvars.hcl .
  ```

* Windows:

  ```shell
  packer build --force -var-file .\photon-4.0-R2.pkrvars.hcl .
  ```

**Example**: Build only the VMware Fusion / Workstation Pro target.

* macOS and Linux:

  ```shell
  packer build --force -only=vmware-iso.vagrant-vmw -var-file=photon-4.0-R2.pkrvars.hcl .
  ```

* Windows:

  ```powershell
  packer build --force -only vmware-iso.vagrant-vmw -var-file .\photon-4.0-R2.pkrvars.hcl .
  ```

**Example**: Build only the VirtualBox target.

* macOS and Linux:

  ```shell
  packer build --force -only=virtualbox-iso.vagrant-vbx -var-file=photon-4.0-R2.pkrvars.hcl .
  ```

* Windows

  ```powershell
  packer build --force -only virtualbox-iso.vagrant-vbx -var-file .\photon-4.0-R2.pkrvars.hcl .
  ```

**Example**: Build only the VMware Fusion / Workstation Pro target with an input variable override for the VMware Photon OS Developer package list.

* macOS and Linux:

  ```shell
  packer build --force -var os_packagelist=developer -only=vmware-iso.vagrant-vmw -var-file=photon-4.0-R2.pkrvars.hcl .
  ```

* Windows:

  ```powershell
  packer build --force -var os_packagelist=developer -only vmware-iso.vagrant-vmw -var-file .\photon-4.0-R2.pkrvars.hcl .
  ```

## Run

After you have created the Vagrant boxes for VMware Photon OS, you can bring them up in your provider of choice.

**Example**: VMware Fusion or VMware Workstation Pro

```shell
cd output
vagrant init photon-4.0-R2-minimal-vagrant-vmw.box
vagrant up --provider vmware_desktop
```

**Example**: VirtualBox

```shell
cd output
vagrant init photon-4.0-R2-minimal-vagrant-vbx.box
vagrant up --provider virtualbox
```

**Example**: SSH to the VMware Photon OS box.

```shell
> vagrant ssh
vagrant@photon-minimal [ ~ ]$ 
```

By default, shared folders are disabled between the Vagrant box and the host.

Edit the `Vagrantfile` to manage the share folders.

**Example**: Enable Shared Folders

```shell
Vagrant.configure("2") do |config|
  config.vm.box = "photon-4.0-R2-minimal-vagrant-vmw.box"
  config.vm.synced_folder '.', '/vagrant', disabled: false
end
```

Edit the `Vagrantfile` to modify additional provider configurations, such as CPU and memory.

**Example**: Modify the CPU and Memory Resources

```shell
Vagrant.configure("2") do |config|
  config.vm.box = "photon-4.0-R2-minimal-vagrant-vmw.box"
  config.vm.provider "vmware_desktop" do |v|
    v.vmx["numvcpus"] = "2"
    v.vmx["memsize"] = "2048"
  end
end
```

Learn more about the Vagrant provider configurations:

* [VMware Provider Configuration][vagrant-provider-config-vmware]
* [VirtualBox Provider Configuration][vagrant-provider-config-virtualbox]

[git]: https://git-scm.com
[packer]: https://packer.io
[vagrant-boxes-photon]: https://app.vagrantup.com/vmware/boxes/photon
[vagrant-download]: https://vagrantup.com/downloads
[vagrant-provider-config-vmware]: https://vagrantup.com/docs/providers/vmware/configuration
[vagrant-provider-config-virtualbox]: https://vagrantup.com/docs/providers/virtualbox/configuration
[vagrant-vmware-utility]: https://www.vagrantup.com/vmware/downloads
[virtualbox]: https://virtualbox.org
[vmware-fusion]: https://vmware.com/products/fusion
[vmware-workstation]: https://mware.com/products/workstation-pro
[vmware-photon]: https://vmware.github.io/photon
[vmware-photon-logo]: logo.png
[vscode]: https://code.visualstudio.com
[vscode-packer]: https://marketplace.visualstudio.com/items?itemName=4ops.packer
