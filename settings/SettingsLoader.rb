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
                Hash[
                    folder.map.with_index do |value, key|
                        if key == 0
                            [:from, value]
                        elsif key == 1
                            [:to, value]
                        else
                            if value.include?('docker') then
                                [:docker, value['docker']]
                            else
                                $stderr.puts "Unkown synced folder argument. Check README.md file for more information."
                                [key, value]
                            end
                        end
                    end
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