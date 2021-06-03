#!/bin/sh

# ------------------------------
# Add and configure vagrant user
# ------------------------------
/bin/echo "Adding vagrant user"
HOME_DIR="/home/vagrant"

# Add vagrant group
/sbin/groupadd vagrant

# Set up a vagrant user and add the insecure key for User to login
/sbin/useradd -G vagrant,docker -m -p '$1$vagrant$I4pvEJo5vdKqeokP0vb9t/' vagrant

# Avoid password expiration (https://github.com/vmware/photon-packer-templates/issues/2)
/bin/chage -I -1 -m 0 -M 99999 -E -1 vagrant

# Configure a sudoers for the vagrant user
/bin/echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant

# Set up insecure vagrant ssh key
/bin/mkdir -m 700 -p ${HOME_DIR}/.ssh
/bin/echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > ${HOME_DIR}/.ssh/authorized_keys
/bin/chmod 600 ${HOME_DIR}/.ssh/authorized_keys
/bin/chown -R vagrant:vagrant ${HOME_DIR}/.ssh

# Reboot to new Kernel before adding kernel modules
/bin/echo "Rebooting VM"
/bin/systemctl reboot

