# VMware [Photon](https://github.com/vmware/photon) [Packer](http://packer.io) templates

## Prerequisites

* [Packer](http://packer.io) > 1.5
* VMware Fusion or Workstation
* Virtualbox (optional)

## Build Photon artifacts

This packer template requires to variables to be set either via a JSON file (preferred) or on the command line:

1. `iso_url` - is the photon ISO for the build.
1. `iso_checksum` - is the hash value of the ISO.
1. `iso_checksum_type` - is the hashing algorithm used.
1. `photon_version` - is the Photon OS version (i.e. 2.0, 3.0, 4.0)
1. `photon_release` - is the Photon OS release (i.e. GA, R2, R3)

Preset JSONs with the required parameters are provided in vars folder.

To kick off a full build of Photon OS 4.0 locally using the preset JSON file:

```shell
packer build -var-file=vars/photon_iso-4.0_GA.json -except=vagrant-cloud packer-photon.json
```

### Build targets

There are two build targets available:

1. `vmware_desktop` - Generates the `vmware_desktop` compatible Vagrant box.
1. `virtualbox` - Generates the `virtualbox` compatible Vagrant box.

To build only a VMware Workstation/Fusion vagrant box:

```shell
packer build -only=vagrant-vmware_desktop -var-file=vars/photon_iso-4.0_GA.json -except=vagrant-cloud packer-photon.json
```

### Vagrant Cloud

A post-provisioner has been added to simplify uploading boxes to the [Vagrant Cloud](https://app.vagrantup.com/vmware/photon).

The packer template expects environmental variables with your Vagrant Cloud User and Vagrant Cloud Token to be set before running the template.

```
export VAGRANT_CLOUD_USER=<user>
export VAGRANT_CLOUD_TOKEN=<token>
```

```shell
packer build -var-file=vars/photon_iso-4.0_GA.json packer-photon.json
```

