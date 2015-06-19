module VM
  class ParameterizedCommand
    def initialize(params: , command: )
      @params  = params
      @command = command
    end

    attr_reader :params, :command
    private     :params, :command

    def name
      command.name
    end

    def write_to(runtime, options = { })
      command.write_to(runtime, params: params)
    end
  end
end
