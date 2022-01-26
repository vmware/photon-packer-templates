# vim:ft=make:

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Defaults

THIS_FILE               := $(lastword $(MAKEFILE_LIST))

PACKER_VAR_FILE         := photon-4.0-R2.pkrvars.hcl
PACKER_ARGS             := -var-file=$(PACKER_VAR_FILE) .
PACKER_BUILDERS         := vmware-iso.vagrant-vmw virtualbox-iso.vagrant-vbx

# Help Targets

.PHONY: help

help:
	@echo "Targets:"
	@echo "  validate"
	@echo "    $(addsuffix \n   , $(addprefix validate-, $(PACKER_BUILDERS)))"
	@echo "  build"
	@echo "    $(addsuffix \n   , $(addprefix build-, $(PACKER_BUILDERS)))"
	@echo "  clean"

# Packer Targets

.PHONY: validate* build* publish*

validate:
	@echo "> Initializing plug-ins..."
	packer init $(PACKER_ARGS)
	@echo "> Validating all builders..."
	packer validate $(PACKER_ARGS)

validate-%:
	@echo "> Initializing plug-ins..."
	packer init -only=$(patsubst validate-%,%, $@) $(PACKER_ARGS)
	@echo "> Validating builder: $(patsubst validate-%,%, $@)."
	packer validate -only=$(patsubst validate-%,%, $@) $(PACKER_ARGS)

build: validate
	@echo "> Building with all builders..."
	packer build --force $(PACKER_ARGS)

build-%:
	@$(MAKE) -f $(THIS_FILE) validate-$(patsubst build-%,%, $@)
	@echo "Building with builder: $(patsubst build-%,%, $@)."
	packer build --force -only=$(patsubst build-%,%, $@) $(PACKER_ARGS)

# Cleanup

.PHONY: clean*

clean:
	./scripts/clean.sh
