#!/bin/sh

HOME_DIR="/home/photon"

# Set up a photon user and add the insecure key for User to login
useradd -G users -m photon

# Configure a sudoers for the photon user
echo "photon ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/photon

# Set up insecure Vagrant key
mkdir -p ${HOME_DIR}/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGj5HgDM5Z4Rf4tZpSuQcUVns7D94rtpoZrQlfZsgpxAKb+r7KpGJnRacYxCKFMqT6Br2f+VKGPMRaNoHeJGenF7RINATmPnTTTZ8BDklOxr/K9awS78CQ+jXvlwEWn+te3ysW7nNYU6LD/pbLy1NFJ2OE+we040+P7wUDbtq5iPBrV6UXAj0W8Bflezk7A2adXSVgssohBbZGoOcHGFfF3qGsPkR20UGtm+GXiSwP6ehBQwacrobWwgCU5CpQArnlaB+l+MW/jr1qjTRcbTDqkFLclq+aaA+qqdKU0VHrFnkCNZASyJ2pL0GUlBUYCU0/aKsXSwVYT8jN+ngMscjp0XG11lPrJw2Zhzl9gBV3uO0wF4IeutJr051Spp3CNCkIbBJGL6ZbMTAOLJQ96ugKlYendVGAqTewgT6tK0/Kh+at8P61pr7gyjqvdlvFesXgq4GP9eKvr5bm770KU+MXMWDtdx4UoraAUV01/asLR4ngxaebLe7kjkEr5ly6MImIxS+hwRrR5XLGPRXRMqGlF/TnWHX1RpIE32uJ2Q/LdwJnOlzpuErWwEZi4mmAUOXoIyCIDJz76JRLP4JRm8EGoSUyYSo7IUhoN1s4Nm5RcWT6kH7iD7WJta71Hxum98pJzBqcCJ3G709cvpBnMsV+NZu6h8vBURx6csZQS55UXQ== photon insecure public key" > ${HOME_DIR}/.ssh/authorized_keys
chown -R photon:users ${HOME_DIR}/.ssh
chmod 700 ${HOME_DIR}/.ssh
chmod 600 ${HOME_DIR}/.ssh/authorized_keys

# Add Docker group
groupadd docker

# Add Photon user to Docker group
usermod -a -G docker photon
