class DockerProvisioner

    @outputLogger
    @vm

    def initialize(vm, outputLogger)
        @outputLogger = outputLogger
        @vm = vm
    end

    def forbid?(folder)
        return if false == folder[:docker]

        dockerFile = folder.fetch(:docker, {}).fetch('dockerfile', 'Dockerfile')
        localPath = folder[:from] + '/' + dockerFile
        expandedPath = File.expand_path(localPath)

        !File.exists?(expandedPath)
    end

    def engage(folder)
        path = folder[:to]

        folder[:docker] ||= {}
        folder[:docker]['dockerfile'] ||= 'Dockerfile'

        options = folder[:docker]

        options['imageName'] ||= path.tr('/', '-').gsub!(/^-/, '')

        options['bindMountSyncedFolder'] ||= [true]
        options['build'] ||= [true]
        options['run'] ||= [true]
        options['env'] ||= {}

        @vm.provision "docker", run: "always" do |d|
            if should('build', options) then
                buildArgs = getArgs('build', options)
                buildArgs.concat(' -t ', options['imageName'])
                buildArgs.concat(' -f ', options['dockerfile'])

                d.build_image path,
                    args: buildArgs
            end

            if should('run', options) then
                runArgs = getArgs('run', options)
                
                runArgs += ' --restart=on-failure' unless 
                    runArgs.downcase().include?('--restart') unless
                        runArgs.downcase().include?('--rm')
                
                if should('bindMountSyncedFolder', options) then
                    mountPath = options['bindMountSyncedFolder'][1]
                    mountPath ||= path
                    
                    runArgs.concat(' ', "-v #{path}:#{mountPath}")

                    runArgs.concat(' ', "--env \"BIND_MOUNT_PATH=#{mountPath}\"")

                    if (options['bindMountSyncedFolder'][2]) then
                        runArgs.concat(' ', "--env \"#{options['bindMountSyncedFolder'][2]}=#{mountPath}\"")
                        runArgs.concat(' ', "--env \"BIND_MOUNT_PATH_VAR_NAME=#{options['bindMountSyncedFolder'][2]}\"")
                    else
                        runArgs.concat(' ', "--env \"BIND_MOUNT_PATH_VAR_NAME=BIND_MOUNT_PATH\"")
                    end
                end

                options['env'].each do |name, value|
                    if value.nil? 
                        runArgs.concat(' ', "--env #{name}")
                    else
                        runArgs.concat(' ', "--env \"#{name}=#{value}\"")
                    end
                end

                d.run options['imageName'],
                    args: runArgs,
                    restart: 'no'
            end
        end
    end

    def should(command, options)
        options[command][0]
    end

    def getArgs(command, options)
        options[command][1..-1].join(' ')
    end
end