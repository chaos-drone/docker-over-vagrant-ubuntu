class ProvisionOutputLogger

    LOG_STDOUT = 1
    LOG_STDERR = 2

    @vm

    def initialize(vm)
        @vm = vm
    end

    def log(message, type = LOG_STDOUT)

        echoCommand = "echo \"#{message}\""

        echoCommand.prepend('>&2 ') if LOG_STDERR == type

        @vm.provision "shell", run: "always",
            inline: echoCommand
    end
end