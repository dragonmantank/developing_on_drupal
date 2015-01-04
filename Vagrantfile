# -*- mode: ruby -*-
# vi: set ft=ruby :

def Kernel.is_windows?
  # Detect if we are running on windows
  processor, platform, *rest = RUBY_PLATFORM.split('-')
  platform == 'mingw32'
end

Vagrant.configure("2") do |config|
  config.vm.box = "puphpet/debian75-x32"
  config.vm.box_url = "puphpet/debian75-x32"

  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 3306, host: 3306, auto_correct: true

  config.vm.synced_folder "./", "/vagrant", type: "nfs"

  config.vm.provision :puppet do |puppet|
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "base.pp"
  end

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end
end