#!/bin/bash

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Minimum security baseline, disabling root user and sshd password authentication.

# Delete the password from the 'root' user account.
/bin/echo '> Deleting the password from the root user account...'
/bin/passwd -d root

# Lock the 'root' user account.
/bin/echo '> Locking the root user account...'
/sbin/usermod -L root

# Disable PermitRootLogin for SSH.
/bin/echo '> Disabling PermitRootLogin for SSH...'
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Disable PasswordAuthentication for SSH.
/bin/echo '> Disabling PasswordAuthentication for SSH...'
/bin/sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
/bin/sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config