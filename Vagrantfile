# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-18.04"

  config.vm.define "dockerVM"

  config.vm.network :private_network, ip: "10.20.1.2"

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
end
