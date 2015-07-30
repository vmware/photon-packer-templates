 #!/bin/sh

# Install VBoxAdditions

# Faking a sysV-based system
if [ ! -d /etc/init.d ]; then mkdir /etc/init.d; fi

# Install required packages.
tdnf --assumeyes install gawk
tdnf --assumeyes install make
tdnf --assumeyes install gcc
tdnf --assumeyes install tar
tdnf --assumeyes install linux-dev
tdnf --assumeyes install binutils
tdnf --assumeyes install linux-api-headers

mkdir /tmp/virtualbox
mount -o loop /root/VBoxGuestAdditions.iso /tmp/virtualbox
sh /tmp/virtualbox/VBoxLinuxAdditions.run
umount /tmp/virtualbox
rmdir /tmp/virtualbox
rm /root/VBoxGuestAdditions.iso

# Remove packages
tdnf --assumeyes erase linux-api-headers
tdnf --assumeyes erase linux-dev
tdnf --assumeyes erase tar
tdnf --assumeyes erase gcc
tdnf --assumeyes erase libgcc-devel
tdnf --assumeyes erase libgomp-devel
tdnf --assumeyes erase libstdc++-devel
tdnf --assumeyes erase mpc
tdnf --assumeyes erase make
tdnf --assumeyes erase binutils
tdnf --assumeyes erase flex
tdnf --assumeyes erase m4
tdnf --assumeyes erase open-vm-tools
tdnf --assumeyes erase perl-DBI

echo "Compacting disk space"
FileSystem=`grep ext /etc/mtab| awk -F" " '{ print $2 }'`

for i in $FileSystem
do
        echo $i
        number=`df -B 512 $i | awk -F" " '{print $3}' | grep -v Used`
        echo $number
        percent=$(echo "scale=0; $number * 98 / 100" | bc )
        echo $percent
        dd count=`echo $percent` if=/dev/zero of=`echo $i`/zf
        /bin/sync
        sleep 15
        rm -f $i/zf
done

tdnf --assumeyes erase gawk

# Remove tdnf cache
rm -rf /var/cache/tdnf/*

# Removing VBox startup files and removing init.d entirely if empty
find /etc/init.d -type f -name "vbox*" -exec rm {} \;
if [ ! "$(ls -A /etc/init.d)" ]; then rmdir /etc/init.d; fi

# Prevent vmhgfs module from loading on virtualbox platforms
if [ -f /etc/modules-load.d/vmhgfs.conf ]; then rm -f /etc/modules-load.d/vmhgfs.conf; fi
