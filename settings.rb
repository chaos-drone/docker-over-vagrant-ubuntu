class Settings
    attr_reader :memory, :name, :box, :ip

    def initialize
        @memory = "2048"
        @name = "dockerVM"
        @box = "bento/ubuntu-18.04"
        @ip = "10.20.1.2"
    end
end