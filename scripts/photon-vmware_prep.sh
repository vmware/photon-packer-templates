#!/bin/sh

/bin/sleep 5
# ------------------------
# Install VMware Additions
# ------------------------
/bin/echo "Applying VMware Additions"

# Use hypervisor optimized kernel
/usr/bin/tdnf install --assumeyes --quiet linux-esx 2>/dev/null

# Set up HGFS generic mount point
/bin/mkdir -p /mnt/hgfs

