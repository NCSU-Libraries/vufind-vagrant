# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu-1310-x64-virtualbox-puppet.box'
  config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-x64-virtualbox-puppet.box'

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
  end

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8080, host: 8088
  config.vm.synced_folder "vufind", "/usr/local/vufind", :owner => 'www-data'
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 3584]
  end
end
