#!/bin/sh

# ---------------------
# Complete system setup
# ---------------------

# Modify Grub configuration
/bin/echo 'GRUB_CMDLINE_LINUX=\"net.ifnames=0\"' >> /etc/default/grub
/bin/sed -i '/linux/ s/$/ net.ifnames=0/' /boot/grub2/grub.cfg
/bin/sed -i 's/OS/Linux/' /etc/photon-release

# Tweak console message
/bin/echo "Adding console information"
DATE=$(/bin/date -I)
/bin/cat <<EOT >> /etc/issue

    Build date: ${DATE}

  IPv4 Address: \4
  IPv6 Address: \6

   Credentials: vagrant / vagrant
                   root / vagrant

EOT

# Clean package cache
/usr/bin/tdnf clean all --quiet

# Zero out disk space
/bin/echo "Zeroing storage"
/bin/dd if=/dev/zero of=/var/EMPTY bs=1M 2>/dev/null
/bin/sync ; /bin/sleep 5; /bin/sync
/bin/rm -f /var/EMPTY

