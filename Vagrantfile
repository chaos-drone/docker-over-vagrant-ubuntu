# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1804"

  config.vm.define "dockerVM"

  config.vagrant.plugins = "vagrant-auto_network"

  config.vm.network :private_network, :auto_network => true
  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
end
