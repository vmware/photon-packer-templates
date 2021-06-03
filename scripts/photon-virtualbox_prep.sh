 #!/bin/bash

/bin/sleep 5

# ----------------------------
# Install Virtualbox Additions
# ----------------------------
/bin/echo "Applying Virtualbox Additions"

# Faking a sysV-based system
/bin/mkdir -p /etc/init.d

# Install required packages.
/usr/bin/tdnf install --assumeyes --quiet \
  binutils gawk gcc linux-api-headers linux-devel make tar

cd /tmp
/bin/mkdir -p /tmp/virtualbox /lib/modules/$(uname -r)
/bin/touch /lib/modules/$(uname -r)/modules.{order,builtin}
/bin/mount -o loop,ro /root/VBoxGuestAdditions.iso /tmp/virtualbox

# Required by Virtualbox script
#/bin/mkdir -p /lib/modules/$(uname -r)
#/bin/touch /lib/modules/$(uname -r)/modules.{order,builtin}

/bin/sh /tmp/virtualbox/VBoxLinuxAdditions.run
/bin/umount /tmp/virtualbox
/bin/rmdir /tmp/virtualbox
#/bin/rm /root/VBoxGuestAdditions.iso

# Remove packages
/usr/bin/tdnf erase --assumeyes --quiet \
  binutils flex gawk gcc libgcc-devel libgomp-devel libstdc++-devel \
  linux-api-headers linux-devel m4 mpc open-vm-tools perl-DBI tar

# Removing VBox startup files and removing init.d entirely if empty
find /etc/init.d -type f -name "vbox*" -exec rm {} \;
if [ ! "$(ls -A /etc/init.d)" ]; then rmdir /etc/init.d; fi

# Prevent vmhgfs module from loading on virtualbox platforms
if [ -f /etc/modules-load.d/vmhgfs.conf ]; then rm -f /etc/modules-load.d/vmhgfs.conf; fi

# Add Virtualbox Kernel Modules
/bin/cat <<EOT > /etc/modules-load.d/virtualbox.conf
# Load Virtualbox kmods at boot
vboxguest
vboxsf
vboxvideo
EOT

