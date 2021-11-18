#!/bin/bash

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Install VirtualBox Guest Additions

/bin/sleep 5

/bin/echo '> Preparing for VirtualBox Guest Additions...'

if [ ! -d /etc/init.d ]; then mkdir /etc/init.d; fi

/bin/echo '> Installing additional packages...'
/usr/bin/tdnf --assumeyes --quiet install \
    binutils \
    gcc \
    linux-api-headers \
    linux-devel \
    make \
    tar

/bin/echo '> Installing the VirtualBox Guest Additions...'
/bin/mkdir -p /tmp/virtualbox /lib/modules/$(uname -r)
/bin/touch /lib/modules/$(uname -r)/modules.{order,builtin}
/bin/mount -r -o loop /root/VBoxGuestAdditions.iso /tmp/virtualbox
/bin/sh /tmp/virtualbox/VBoxLinuxAdditions.run
/bin/umount /tmp/virtualbox
/bin/rmdir /tmp/virtualbox

/bin/echo '> Removing packages...'
/usr/bin/tdnf --assumeyes --quiet erase \
    binutils \
    flex \
    gawk \
    gcc \
    libgcc-devel \
    libgomp-devel \
    libstdc++-devel \
    linux-api-headers \
    linux-devel \
    m4 \
    mpc \
    open-vm-tools \
    perl-DBI \
    tar

/bin/echo '> Removing VirtualBox startup files and removing init.d...'
find /etc/init.d -type f -name "vbox*" -exec rm {} \;
if [ ! "$(ls -A /etc/init.d)" ]; then rmdir /etc/init.d; fi

/bin/echo '> Preventing the vmhgfs module from loading on VirtualBox...'
if [ -f /etc/modules-load.d/vmhgfs.conf ]; then rm -f /etc/modules-load.d/vmhgfs.conf; fi

/bin/echo '> Adding VirtualBox Kernel Modules...'
/bin/cat << EOT > /etc/modules-load.d/virtualbox.conf
# Load Virtualbox kmods at boot
vboxguest
vboxsf
vboxvideo
EOT

/bin/echo '> Completed the VirtualBox Guest Additions.'