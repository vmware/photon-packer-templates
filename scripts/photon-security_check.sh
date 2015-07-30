#!/bin/bash
# Minimum security baseline, disabling root user and sshd password
# authentication

# Remove root password
passwd -d root

# Lock root user
usermod -L root

# Restore login only through unprivileged users:
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Disable Password Authentication:
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
