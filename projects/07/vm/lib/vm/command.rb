require_relative "parameterized_command"

module VM
  class Command
    def initialize(name: , params: { }, operations: )
      @name       = name
      @params     = params
      @operations = operations
    end

    attr_reader :name

    attr_reader :params, :operations
    private     :params, :operations

    def parse(tokens)
      command =
        if tokens[0] =~ /\A#{Regexp.escape(name)}\z/ && params_match?(tokens)
          ParameterizedCommand.new(
            params:  Hash[params.keys.zip(tokens.drop(1).take(params.size))],
            command: self
          )
        else
          nil
        end
      tokens  = tokens.send(*(command ? [:drop, 1 + params.size] : :itself))
      [command, tokens]
    end

    def write_to(runtime, options = { })
      operations.write_to(runtime, command: name, params: options[:params])
    end

    private

    def params_match?(tokens)
      params.values.zip(tokens.drop(1).take(params.size)) do |test, arg|
        return false unless test === arg
      end
      true
    end
  end
end
