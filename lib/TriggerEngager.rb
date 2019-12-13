class TriggerEngager

    def engageDocker(trigger, folder)
        if isDockerTriggerEngageable?(folder) then
            trigger.engage(folder)
        end
    end

    def engageDockerCompose(trigger, folder)
        if isDockerComposeTriggerEngageable?(folder) then
            trigger.engage(folder)
        end
    end

    def isDockerTriggerEngageable?(folder)
        return if false == folder[:docker]

        localPath = folder[:from] + folder[:docker]['dockerfile'].sub(folder[:to], '')
        expandedPath = File.expand_path(localPath)
        
        File.exists?(expandedPath)
    end

    def isDockerComposeTriggerEngageable?(folder)
        File.exists?(File.expand_path("#{folder[:from]}/docker-compose.yaml"));
    end
end