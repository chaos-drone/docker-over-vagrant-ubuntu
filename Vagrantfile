# -*- mode: ruby -*-
# vi: set ft=ruby :

defaultSettingsFilePath = File.expand_path(File.dirname(__FILE__) + '/settings/defaults.yaml')
userSettingsFilePath = File.expand_path(File.dirname(__FILE__) + '/settings/settings.yaml')
userConfigureClassPath = File.expand_path(File.dirname(__FILE__) + '/settings/UserConfigure.rb')

require File.expand_path(File.dirname(__FILE__) + '/settings/SettingsLoader.rb')
require File.expand_path(File.dirname(__FILE__) + '/ProvisionOutputLogger.rb')
require File.expand_path(File.dirname(__FILE__) + '/DockerProvisioner.rb')
require File.expand_path(File.dirname(__FILE__) + '/DockerComposeProvisioner.rb')

Vagrant.configure("2") do |config|

  settingsLoader = SettingsLoader.new(defaultSettingsFilePath, userSettingsFilePath)
  settings = settingsLoader.get

  config.vm.box = settings['box']

  config.vm.define settings['name']

  config.vm.network :private_network, ip: settings['ip']

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", settings['memory']]
  end

  outputLogger = ProvisionOutputLogger.new(config.vm)
  dockerProvisioner = DockerProvisioner.new(config.vm, outputLogger)
  dockerComposeProvisioner = DockerComposeProvisioner.new(config.vm)

  existantSyncedFoldres = settings['synced_folders'].select do |folder| 
    File.exists? File.expand_path(folder[:from])
  end

  existantSyncedFoldres.each do |folder|
      config.vm.synced_folder folder[:from], folder[:to]
      dockerProvisioner.engage(folder) unless dockerProvisioner.forbid?(folder)
      dockerComposeProvisioner.engage(folder) unless dockerComposeProvisioner.forbid?(folder)
  end

  nonExistantSyncedFoldres = settings['synced_folders'] - existantSyncedFoldres

  nonExistantSyncedFoldres.each do |folder|
    outputLogger.log "Unable to mount #{folder[:from]}. Please, check your synced_folders configuration in settings.yaml.",
        ProvisionOutputLogger::LOG_STDERR
  end

  if File.exists? userConfigureClassPath
    require userConfigureClassPath

    userConfig = UserConfigure.new
    userConfig.configure(config, settings)
  end

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
end
