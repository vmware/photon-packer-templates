#!/bin/bash

# -------------------------
# Minimum security baseline
# -------------------------
# Disable root from logging in over SSH
/bin/echo "Disabling root log in over SSH"
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Disable password authentication for all users
/bin/echo "Disabling password authentication"
/bin/sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
/bin/sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
