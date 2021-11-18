#!/bin/bash

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Configure the default local user.

export VAGRANT_USERNAME
export VAGRANT_PASSWORD
export VAGRANT_KEY

HOME_DIR="/home/$VAGRANT_USERNAME"

/bin/echo '> Adding the' $VAGRANT_USERNAME 'group for the local' $VAGRANT_USERNAME 'user...'
/sbin/groupadd $VAGRANT_USERNAME

/bin/echo '> Adding the local' $VAGRANT_USERNAME 'user ...'
/sbin/useradd -g $VAGRANT_USERNAME -m -s /bin/bash $VAGRANT_USERNAME
/sbin/usermod -aG sudo $VAGRANT_USERNAME
/bin/echo $VAGRANT_USERNAME:$VAGRANT_PASSWORD | sudo chpasswd

/bin/echo '> Adding the local' $VAGRANT_USERNAME 'user to the docker group...'
/sbin/usermod -aG docker $VAGRANT_USERNAME

/bin/echo '> Adding insecure public key for the local' $VAGRANT_USERNAME 'user...'
/bin/mkdir -p ${HOME_DIR}/.ssh
/bin/cat << EOF > ${HOME_DIR}/.ssh/authorized_keys
$VAGRANT_KEY
EOF
/bin/chown -R $VAGRANT_USERNAME:$VAGRANT_USERNAME ${HOME_DIR}/.ssh
/bin/chmod 700 ${HOME_DIR}/.ssh
/bin/chmod 644 ${HOME_DIR}/.ssh/authorized_keys

/bin/echo '> Adding the local' $VAGRANT_USERNAME 'user to passwordless sudoers...'
/bin/bash -c "echo \"$VAGRANT_USERNAME ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers"

/bin/echo '> Setting the local' $VAGRANT_USERNAME 'user password expiration...'
/bin/chage -I -1 -m 0 -M 99999 -E -1 $VAGRANT_USERNAME

# Reboot the virtual machine before adding kernel modules.

 /bin/echo "> Rebooting the virtual machine before adding kernel modules..."
 /bin/systemctl reboot