#!/bin/bash

# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Configure GRUB settings.

/bin/echo '> Configuring GRUB settings...'
/bin/sed -i '/linux/ s/$/ net.ifnames=0/' /boot/grub2/grub.cfg
/bin/echo 'GRUB_CMDLINE_LINUX=\"net.ifnames=0\"' >> /etc/default/grub
/bin/sed -i 's/OS/Linux/' /etc/photon-release

# Zero out disk space.

/bin/echo "> Zeroing out disk space..."
/bin/dd if=/dev/zero of=/var/EMPTY bs=1M 2>/dev/null
/bin/sync ; /bin/sleep 5; /bin/sync
/bin/rm -f /var/EMPTY

# Clean tdnf.

/bin/echo '> Cleaning tdnf...'
/usr/bin/tdnf clean all --quiet