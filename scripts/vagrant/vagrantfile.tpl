Vagrant.require_version '>= 2.2.19'
Vagrant.configure('2') do |config|
  config.nfs.functional = false
  config.vm.synced_folder '.', '/vagrant', disabled: true  
  
  config.vm.provider "virtualbox" do |v|
    v.customize ['modifyvm', :id, '--acpi', 'off']
    if Vagrant.has_plugin?("vagrant-vbguest")
        override.vbguest.no_install = true
    end
  end

  ["vmware_desktop"].each do |p|
    config.vm.provider p do |v|
      v.vmx["ethernet0.virtualDev"] = "vmxnet3"
      v.vmx["scsi0.virtualDev"]     = "pvscsi"
      v.whitelist_verified          = true
    end
  end
end