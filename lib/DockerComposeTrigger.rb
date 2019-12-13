class DockerComposeTrigger
    
    @vm

    def initialize(vm)
        @vm = vm
    end

    def engage(folder)
        @vm.provision "shell", run: "always",
            inline: "cd #{folder[:to]} && docker-compose -f #{folder[:to]}/docker-compose.yaml up -d"
    end
end