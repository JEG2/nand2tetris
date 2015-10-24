require_relative "commands"

module VM
  class Parser
    def initialize(vm_code)
      @vm_code = vm_code
    end

    attr_reader :vm_code
    private     :vm_code

    def parse
      tokens   = vm_code.gsub(%r{//.*}, "").scan(/\S+/)
      commands = [ ]
      until tokens.empty?
        COMMANDS.each do |command|
          parsed_command, remaining_tokens = command.parse(tokens)
          if parsed_command
            commands << parsed_command
            tokens    = remaining_tokens
            break
          end
        end
      end
      commands
    end
  end
end
