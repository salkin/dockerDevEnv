# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative "scripts"

$PROXY = "http://10.144.1.10:8080"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "opensuse/openSUSE-Tumbleweed-x86_64"
  config.proxy.http = $PROXY
  config.proxy.https = $PROXY
  config.vm.define "master" do |inner|
    inner.vm.provision "shell" do |s|
      s.inline = Script::CONSUL
      s.args = "192.168.50.100"
    end
    inner.vm.provision "shell" do |s| 
      s.inline =  Script::BOOTSTRAP
      s.args = "192.168.50.100 192.168.50.100"
    end
    inner.vm.provision "shell" do |s| 
      s.inline =  Script::MASTER_SETUP
    end

    inner.vm.hostname = "master"
    inner.vm.network "private_network", ip: "192.168.50.100"  
    #Consul setup

  end
  
  node_boxes = [
      { :name => "node1", :ip => "192.168.50.101" },
      { :name => "node2", :ip => "192.168.50.102" }
  ]

  node_boxes.each do |opts|

    config.vm.define opts[:name] do |inner|

    inner.vm.provision "shell" do |s| 
      s.inline =  Script::BOOTSTRAP
      s.args = "192.168.50.100", opts[:ip]
    end
    
    inner.vm.provision "shell" do |s| 
      s.inline =  Script::NODE_SETUP
      s.args = "192.168.50.100"
    end

      inner.vm.hostname = opts[:name]
        config.vm.network "private_network", ip: opts[:ip]  
    end
  end




end
