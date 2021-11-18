#!/bin/bash

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

source /etc/os-release

# Updating the package repository for versions prior to VMware Photon OS 4.0.

if [ $VERSION != "4.0" ]; then
    /bin/echo "> Updating the package repository for VMware Photon OS $VERSION..."
    for repo in $(ls /etc/yum.repos.d/photon* | grep -v "\-iso")
    do
        /bin/sed -i 's#https.*/#https://packages.vmware.com/photon/$releasever/#' $repo
    done
fi

# Update the guest operating system.

/bin/echo '> Updating the guest operating system...'
/usr/bin/tdnf distro-sync --assumeyes --quiet 2>&1 | sort -u -k 1,1