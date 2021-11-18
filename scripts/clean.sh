#!/bin/bash

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Cleanup the systwm.

/bin/echo '> Removing the Vagrant boxes and configuration files...'
/bin/rm -rf output/.vagrant*
/bin/rm -rf output/*.box
/bin/rm -rf output/*.json
/bin/rm -rf output/Vagrantfile
/bin/echo '> Clearing the Packer cache...'
/bin/rm -rf packer_cache/*
/bin/rmdir packer_cache
/bin/echo '> Done.'