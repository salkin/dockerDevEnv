# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative "scripts"

#Set your proxy endpoint if behind proxy
$PROXY = "http://10.144.1.10:8080"

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
    if $PROXY.length > 0
      inner.vm.provision "shell" do |s|
        s.inline = Script::PROXY_SETUP
        s.args = $PROXY
      end
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
    
    if $PROXY.length > 0
      inner.vm.provision "shell" do |s|
        s.inline = Script::PROXY_SETUP
        s.args = $PROXY
      end
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
