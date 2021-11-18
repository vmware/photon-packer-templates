#!/bin/bash

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/bin/sleep 5

/bin/echo '> Preparing for VMware Guest Additions...'

# Add the hypervisor-optimized kernel.
echo '> Adding the hypervisor-optimized kernel...'
/usr/bin/tdnf install --assumeyes --quiet linux-esx 2>/dev/null

# Add a generic HGFS mountpoint for shared folders.
echo '> Adding a generic HGFS mountpoint for shared folders...'
mkdir -p /mnt/hgfs

/bin/echo '> Completed the VMware Guest Additions.'