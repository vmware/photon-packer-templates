![VMware Photon OS](logo.png)

# Packer Templates for VMware Photon OS

<img alt="VMware Fusion" src="https://img.shields.io/badge/VMware%20Fusion-12+-blue?style=for-the-badge"> <img alt="VMware Workstation Pro" src="https://img.shields.io/badge/VMware%20Workstation%20Pro-16+-blue?style=for-the-badge"> <img alt="VirtualBox" src="https://img.shields.io/badge/VirtualBox-6.1+-blue?style=for-the-badge"><br/>
<img alt="Packer" src="https://img.shields.io/badge/Packer-1.7.8+-blue?style=for-the-badge&logo=packer">
<img alt="Vagrant" src="https://img.shields.io/badge/Vagrant-2.2.19+-blue?style=for-the-badge&logo=vagrant">

## Introduction

This repository provides infrastructure-as-code examples to automate the creation of  [VMware Photon OS](https://vmware.github.io/photon/) ( `x86_64` ) machine images as Vagrant boxes using Packer. These Vagrant boxes can be run on VMware Fusion, VMware Workstation Pro, and VirtualBox. 

This project is also used to generate the offical [`vmware/photon`](https://app.vagrantup.com/vmware/boxes/photon) Vagrant boxes.

All examples are authored in the HashiCorp Configuration Language ("HCL2").

The following builds are available:

* VMware Photon OS 4.0 R1 (default)
* VMware Photon OS 3.0 R3

## Requirements

* [HashiCorp Packer](https://packer.io) 1.7.8 or later
  - Packer Plugin for VMware ( `vmware-iso` ) 1.0.3 or later
  - Packer Plugin for Virtualbox ( `virtualbox-iso` ) 1.0.3 or later (Optional)
 
      > Required Packer plugins are automatically downloaded and initialized when using the `Makefile`. 
      > 
      > For dark sites, you may download the plugins and place these same directory as your Packer executable `/usr/local/bin` or `$HOME/.packer.d/plugins`.

* [HashiCorp Vagrant](https://www.vagrantup.com/downloads) 2.2.19 or later
  - Vagrant Plugin for VMware ( `vagrant-vmware-desktop` ) 3.0.1 or later
  - Vagrant [VMware Utility](https://www.vagrantup.com/vmware/downloads) 1.0.21 or later

* [VMware Fusion](https://www.vmware.com/products/fusion) 12 or later for macOS, or
* [VMware Workstation Pro](https://www.vmware.com/products/workstation-pro) 16 or later for Windows / Linux

* [Virtualbox](https://virtualbox.org) 6.1 or later (Optional)

The following software packages are recommened to be installed on the Packer host:

* Git

  Used for cloning the project repository.For information on installing the Git Command line tools, see [Git](https://git-scm.com).

* Microsoft Visual Code
  
  Used for editing configrations. For information on installing Microsoft Visual Studio Code, see [Visual Studio Code](https://code.visualstudio.com/).
  
  The Visual Studio Code extension for Packer 0.2.0 or later is also recommended for syntax support. Learn more on the [Visual Studio Code Marketplace](https://marketplace.visualstudio.com/items?itemName=4ops.packer).

## Get Started

### Step 1 - Clone the Repository.

Clone the project repository.

  **Example**:

  ```
  git clone https://github.com/vmware/photon-packer-templates.git
  ```

  The general directory structure of the repository.

  ```
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

1. Obtain the URL, checksum type (_e.g._ `sha1`), and checksum value for the VMware Photon OS `.iso` image. This will be use in the build input variables.

2. Obtain the `sha256` checksum value for the VirtualBox Guest Additions `.iso` image. This will be use as input variables when building for VirtualBox.

3. Update the contents of the `photon-<version>-<release>.pkrvars.hcl` file, as needed.

    ```hcl
    // VMware Photon OS Settings

    os_version         = "4.0"
    os_release         = "R1"
    iso_checksum_type  = "sha1"
    iso_checksum_value = "bec6359661b43ff15ac02b037f8028ae116dadb3"
    iso_url            = "https://packages.vmware.com/photon/4.0/Rev1/iso/photon-4.0-ca7c9e933.iso"

    // VirtualBox Guest Additions

    guest_additions_url      = "https://download.virtualbox.org/virtualbox/6.1.28/VBoxGuestAdditions_6.1.28.iso"
    guest_additions_checksum = "eab85206cfb9d7087982deb2635d19a4244a3c6783622a4817fb1a31e48e98e5"
    ```

4.  Modify the Overrides (Optional)

    The project sets input defaults in the `variables.pkr.hcl`. You can override the defaults by editing the `override.okr.hcl` file and uncommenting the relevent overrides.

    ```hcl
    # Override the default input variable values.

    # os_packagelist           = "minimal"
    # vm_name                  = "photon"
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
**Example**: Build only the VMware VMware Fusion / Workstation Pro target.

```shell
make build-vmware-iso.vagrant-vmw
```

Alternatively, you can manually initilize, validate, and build on macOS, Linux, and Windows.

**Example**: Initialize for all targets.

* macOS and Linux:

  ```shell
  packer init -var-file=photon-4.0-R1.pkrvars.hcl .
  ```

* Windows:

  ```powershell
  packer init -var-file .\photon-4.0-R1.pkrvars.hcl .
  ```

**Example**: Validate all targets.

* macOS and Linux:

  ```shell
  packer validate -var-file=photon-4.0-R1.pkrvars.hcl .
  ```

* Windows:

  ```powershell
  packer validate -var-file .\photon-4.0-R1.pkrvars.hcl .
  ```

**Example**: Build all targets.

* macOS and Linux:

  ```shell
  packer build --force -var-file=photon-4.0-R1.pkrvars.hcl .
  ```

* Windows:

  ```shell
  packer build --force -var-file .\photon-4.0-R1.pkrvars.hcl .
  ```

**Example**: Build only the VMware Fusion / Workstation Pro target.

* macOS and Linux:

  ```shell
  packer build --force -only=vmware-iso.vagrant-vmw -var-file=photon-4.0-R1.pkrvars.hcl .
  ```
* Windows:

  ```powershell
  packer build --force -only vmware-iso.vagrant-vmw -var-file .\photon-4.0-R1.pkrvars.hcl .
  ```

**Example**: Build only the VirtualBox target.

* macOS and Linux:

  ```shell
  packer build --force -only=virtualbox-iso.vagrant-vbx -var-file=photon-4.0-R1.pkrvars.hcl .
  ```

* Windows

  ```powershell
  packer build --force -only virtualbox-iso.vagrant-vbx -var-file .\photon-4.0-R1.pkrvars.hcl .
  ```

**Example**: Build only the VMware Fusion / Workstation Pro target with an input variable override for the VMware Photon OS Developer package list.

* macOS and Linux:

  ```shell
  packer build --force -var os_packagelist=developer -only=vmware-iso.vagrant-vmw -var-file=photon-4.0-R1.pkrvars.hcl .
  ```

* Windows:

  ```powershell
  packer build --force -var os_packagelist=developer -only vmware-iso.vagrant-vmw -var-file .\photon-4.0-R1.pkrvars.hcl .
  ```

## Run

After you have created the Vagrant boxes for VMware Photon OS, you can bring them up in your provider of choice.

**Example**: VMware Fusion or VMware Workstation Pro

```shell
cd output
vagrant init photon-4.0-R1-minimal-vagrant-vmw.box
vagrant up --provider vmware_desktop
```

**Example**: VirtualBox

```shell
cd output
vagrant init photon-4.0-R1-minimal-vagrant-vbx.box
vagrant up --provider virtualbox
```

**Example**: SSH to the VMware Photon OS box.
```
> vagrant ssh
vagrant@photon-minimal [ ~ ]$ 
```

By default, shared folders are disabled between the Vagrant box and the host. 

Edit the `Vagrantfile` to manage the share folders.

**Example**: Enable Shared Folders

```shell
Vagrant.configure("2") do |config|
  config.vm.box = "photon-4.0-R1-minimal-vagrant-vmw.box"
  config.vm.synced_folder '.', '/vagrant', disabled: false
end
```
Edit the `Vagrantfile` to modify additional provider configurations, such as CPU and memory.

**Example**: Modify the CPU and Memory Resources

```shell
Vagrant.configure("2") do |config|
  config.vm.box = "photon-4.0-R1-minimal-vagrant-vmw.box"
  config.vm.provider "vmware_desktop" do |v|
    v.vmx["numvcpus"] = "2"
    v.vmx["memsize"] = "2048"
  end
end
```

Learn more about the Vagrant provider configurations:
* [VMware Provider Configuration](https://www.vagrantup.com/docs/providers/vmware/configuration)
* [VirtualBox Provider Configuration](https://www.vagrantup.com/docs/providers/virtualbox/configuration)
