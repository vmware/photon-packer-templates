# VMware [Photon](https://github.com/vmware/photon) [Packer](http://packer.io) templates


## Prerequisites

* [Packer](http://packer.io) > 1.7.x
* VMware Fusion or Workstation
* Virtualbox (optional)

## Build Photon artifacts

This packer template requires to variables to be set either via command line or separate JSON file:

1. `iso_file` - is the photon ISO for the build (can be local or remote).
1. `iso_sha1sum` - is the SHA1 sum of the ISO you want to build.
1. `product_version` - is the PhotonOS release version (will be added to the image filename)

Preset JSONs with the required parameters are provided in vars folder.

To kick off a full build using a preset:

```shell
packer build -var-file=vars/iso-4.0GA.json packer-photon.json.pkr.hcl
```

   "product_version" : "4.0GA",
   "iso_sha1sum" : "sha1:7e834b8b152e12fd7556e4e8e0e26f6ab5bf2737",
   "iso_file" : "https://packages.vmware.com/photon/4.0/GA/iso/photon-minimal-4.0-1526e30ba.iso"

or manually:
```shell
packer build \
        -var 'iso_file=https://packages.vmware.com/photon/4.0/GA/iso/photon-minimal-4.0-1526e30ba.iso' \
        -var 'iso_sha1sum=sha1:7e834b8b152e12fd7556e4e8e0e26f6ab5bf2737' \
        -var 'product_version=4.0GA' \
        packer-photon.json
```

To build only a VMware workstation/fusion vagrant box:
```shell
packer build -only=vmware-iso.vagrant-vmware_desktop -var-file=vars/iso-4.0GA.json packer-photon.json.pkr.hcl
```
or:
```shell
packer build \
        -only=vmware-iso.vagrant-vmware_desktop \
        -var 'iso_file=https://packages.vmware.com/photon/4.0/GA/iso/photon-minimal-4.0-1526e30ba.iso' \
        -var 'iso_sha1sum=sha1:7e834b8b152e12fd7556e4e8e0e26f6ab5bf2737' \
        -var 'product_version=4.0GA' \
        packer-photon.json
```

There are two build targets available:

1. `vagrant-vmware_desktop` - Generates the `vmware_desktop` compatible box found on Atlas as [`vmware/photon`](https://atlas.hashicorp.com/vmware/photon).
1. `vagrant-virtualbox` - Generates the `virtualbox` compatible box found on Atlas as [`vmware/photon`](https://atlas.hashicorp.com/vmware/photon).

## Legal

Copyright © 2015-2021 VMware, Inc.  All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the “License”); you may not
use this file except in compliance with the License.  You may obtain a copy of
the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an “AS IS” BASIS, without warranties or
conditions of any kind, EITHER EXPRESS OR IMPLIED.  See the License for the
specific language governing permissions and limitations under the License.
