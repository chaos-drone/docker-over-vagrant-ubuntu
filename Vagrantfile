# -*- mode: ruby -*-
# vi: set ft=ruby :

# require 'json'

defaultSettingsFilePath = File.expand_path(File.dirname(__FILE__) + '/defaults.yaml')
userSettingsFilePath = File.expand_path(File.dirname(__FILE__) + '/settings.yaml')

require File.expand_path(File.dirname(__FILE__) + '/SettingsLoader.rb')

Vagrant.configure("2") do |config|

  settingsLoader = SettingsLoader.new(defaultSettingsFilePath, userSettingsFilePath)
  settings = settingsLoader.get

  config.vm.box = settings['box']

  config.vm.define settings['name']

  config.vm.network :private_network, ip: settings['ip']

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", settings['memory']]
  end

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
end
