# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 :

Vagrant.configure('2') do |config|
  config.vm.box = "puppetlabs/centos-7.2-64-puppet"

  config.vm.provision :shell do |s|
      # ensure apache, php, and git are all installed
      # first so we can mount the vufind dir
      # the others allow installing vufind components
      s.inline = "yum install -y httpd php git"
  end

  config.vm.provision :file, source: "./files/vufind.service", destination: "/tmp/vufind.service" do |f|
  end

  config.vm.provision :puppet do |puppet|
    puppet.environment_path = "environments"
    puppet.environment = "test"
  end

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8080, host: 8088


  config.vm.synced_folder "vufind", "/usr/local/vufind", :mode => '0775', mount_options: ["uid=48,gid=48"]
  # VirtualBox synced folders can be slow (e.g. spending 97% of a five second
  # page load in spl_autoload), so to use NFS instead:
  #config.vm.network :private_network, :ip => '192.168.42.42'
  #config.vm.synced_folder "vufind", "/usr/local/vufind", :nfs => true

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 3584]
    # The following may help with indexing performance:
    # v.customize ["modifyvm", :id, "--ioapic", "on"]
    # v.customize ["modifyvm", :id, "--cpus", 4]
  end
end
