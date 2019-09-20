# -*- mode: ruby -*-
# vi: set ft=ruby :

require File.expand_path(File.dirname(__FILE__) + '/settings.rb')

Vagrant.configure("2") do |config|

  settings = Settings.new

  config.vm.box = settings.box

  config.vm.define settings.name

  config.vm.network :private_network, ip: settings.ip

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", settings.memory]
  end

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
end
