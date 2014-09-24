# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 :

Vagrant.configure('2') do |config|
  config.vm.box = 'puppetlabs/ubuntu-14.04-64-puppet'

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
  end

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8080, host: 8088

  config.vm.synced_folder "vufind", "/usr/local/vufind", :owner => 'www-data'
  # VirtualBox synced folders can be slow (e.g. spending 97% of a five second
  # page load in spl_autoload), so to use NFS instead:
  #config.vm.network :private_network, :ip => '192.168.42.42'
  #config.vm.synced_folder "vufind", "/usr/local/vufind", :nfs => true

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 3584]
  end
end
