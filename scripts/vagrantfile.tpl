Vagrant.require_version '>= 2.0.0'

Vagrant.configure('2') do |config|
  config.vm.synced_folder '.', '/vagrant', disabled: true
  # We don't have NFS working inside Photon.
  config.nfs.functional = false

  ['vmware_fusion', 'vmware_workstation', 'vmware_appcatalyst'].each do |p|
    config.vm.provider p do |v|
      # Use paravirtualized virtual hardware on VMW hypervisors
      v.vmx['ethernet0.virtualDev'] = 'vmxnet3'
      v.vmx['scsi0.virtualDev'] = 'pvscsi'
      # persistent device naming whitelist
      v.whitelist_verified = true
    end
  end
  config.vm.provider "virtualbox" do |v|
    v.customize ['modifyvm', :id, '--acpi', 'off']
  end
end

