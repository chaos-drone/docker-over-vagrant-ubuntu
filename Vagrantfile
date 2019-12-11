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
  DockerProvisioner.setup(config, outputLogger)
  dockerComposeProvisioner = DockerComposeProvisioner.new(config.vm)

  settings['synced_folders'].each do |folder|
    if File.exists? File.expand_path(folder[:from])
      config.vm.synced_folder folder[:from], folder[:to]

      DockerProvisioner.lookForDocker(folder)
      dockerComposeProvisioner.engage(folder) unless dockerComposeProvisioner.forbid?(folder)
    else
      outputLogger.log "Unable to mount #{folder[:from]}. Please, check your synced_folders configuration in settings.yaml.",
        ProvisionOutputLogger::LOG_STDERR
    end
  end

  if File.exists? userConfigureClassPath
    require userConfigureClassPath

    userConfig = UserConfigure.new
    userConfig.configure(config, settings)
  end

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
end
