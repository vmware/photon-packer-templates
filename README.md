# VMware [Photon](https://github.com/vmware/photon) [Packer](http://packer.io) templates


## Prerequisites

* [Packer](http://packer.io) > 0.8
* VMware Fusion or Workstation
* Virtualbox (optional)

## Build Photon artifacts

This packer template requires to variables to be set either via command line or separate JSON file:

1. `iso_file` - is the photon ISO for the build (can be local or remote).
1. `iso_sha1sum` - is the SHA1 sum of the ISO you want to build.

To kick off a full build:

```shell
packer build \
        -var 'iso_file=https://bintray.com/artifact/download/vmware/photon/iso/1.0TP2/x86_64/photon-minimal-1.0TP2.iso' \
        -var 'iso_sha1sum=a47567368458acd8c8ef5f1e3f793c5329063dac' \
        packer-photon.json
```

To build only a subset:

```shell
packer build \
       -only=<build target>,<build target> \
       -var 'iso_file=https://bintray.com/artifact/download/vmware/photon/iso/1.0TP2/x86_64/photon-minimal-1.0TP2.iso' \
       -var 'iso_sha1sum=a47567368458acd8c8ef5f1e3f793c5329063dac' \
       packer-photon.json
```

There are three build targets available:

1. `appcatalyst` - Generates the same VM that is shipped with [VMware AppCatalyst®](https://communities.vmware.com/community/vmtn/devops/vmware-appcatalyst).
1. `vagrant-vmware_desktop` - Generates the `vmware_desktop` compatible box found on Atlas as [`vmware/photon`](https://atlas.hashicorp.com/vmware/photon).
1. `vagrant-virtualbox` - Generates the `virtualbox` compatible box found on Atlas as [`vmware/photon`](https://atlas.hashicorp.com/vmware/photon).

## Legal

Copyright © 2015 VMware, Inc.  All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the “License”); you may not
use this file except in compliance with the License.  You may obtain a copy of
the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an “AS IS” BASIS, without warranties or
conditions of any kind, EITHER EXPRESS OR IMPLIED.  See the License for the
specific language governing permissions and limitations under the License.
