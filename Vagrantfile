# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1804"

  config.vagrant.plugins = "vagrant-auto_network"

  config.vm.network :private_network, :auto_network => true
end
