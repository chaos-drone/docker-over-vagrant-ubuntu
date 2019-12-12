class SettingsLoader

    def initialize(defaultSettingsFilePath, userSettingsFilePath)
        defaultSettings = YAML::load(File.read(defaultSettingsFilePath))

        if File.exist? userSettingsFilePath then
            userSettings = YAML::load(File.read(userSettingsFilePath))

            if userSettings then
                @settings = mergeRecursive(defaultSettings, userSettings)
            else
                @settings = defaultSettings
                # Todo: When output of YAML::load can be false?
                # Is it only when file is empty, or if it is incorrect
                # Todo: Throw exception and abort when settings file is not ok
                print "Settings file found but cannot be parsed.\n"
            end

            @settings['synced_folders'] ||= []

            @settings['synced_folders'].map!.with_index do |folder, i|
                docker = {}
                folder.each do |value|
                    if value.include?('docker') then
                        docker = value['docker']
                    end
                end

                pathFrom = folder[0]
                pathTo = folder[1]
                
                unless false == docker then
                    docker['dockerfile'] ||= 'Dockerfile'
                    docker['dockerfile'].prepend(pathTo, '/')
                    docker['imageName'] ||= pathTo.tr('/', '-').gsub!(/^-/, '')
                    docker['bindMountSyncedFolder'] ||= [true]
                    docker['build'] ||= [true]
                    docker['run'] ||= [true]
                    docker['env'] ||= {}
                end

                Hash[
                    :from => pathFrom, 
                    :to => pathTo,
                    :docker => docker
                ]
            end
        else
            puts "Settings file not found at #{settingsFilePath}. Will use default settings."
        end
    end

    def mergeRecursive(defaultSettings, userSettings)
        if defaultSettings.is_a?(Hash)
            defaultSettings.merge(userSettings) {|key, defaultItem, userItem| mergeRecursive(defaultItem, userItem)}
        else
            userSettings
        end
    end
    private :mergeRecursive

    def get
        @settings
    end
end