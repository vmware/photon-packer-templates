#!/bin/bash

# --------------------------------
# Update repositories and packages
# --------------------------------
source /etc/os-release

# Photon OS ISOs from GitHub repo have old package repositories.
if [ $VERSION != "4.0" ]; then
  /bin/echo "Fixing package repositories ($VERSION)"
  for repo in $(ls /etc/yum.repos.d/photon* | grep -v "\-iso")
  do
    /bin/sed -i 's#https.*/#https://packages.vmware.com/photon/$releasever/#' $repo
  done
fi

# Update to latest packages
/bin/echo "Updating packages"
/usr/bin/tdnf distro-sync --assumeyes --quiet 2>&1 | sort -u -k 1,1

# Install sudo
/usr/bin/tdnf install --assumeyes --quiet --refresh sudo

