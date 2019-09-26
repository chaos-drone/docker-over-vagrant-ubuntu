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

  if settings.include? 'synced_folders' then
    settings['synced_folders'].each do |folder|

      if File.exists? File.expand_path(folder[0])
        config.vm.synced_folder folder[0], folder[1]
      else
        config.vm.provision "shell",
          inline: "echo \"Unable to mount #{folder[0]}. Please, check your synced_folders configuration in settings.yaml.\""
      end
    end
  end

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
end
