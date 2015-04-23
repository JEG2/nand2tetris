require_relative "a_instruction"
require_relative "l_instruction"
require_relative "c_instruction"

module Assembler
  class InstructionIdentifier
    include Enumerable

    def initialize(parser)
      @parser  = parser
      @address = 0
    end

    attr_reader :parser, :address
    private     :parser, :address

    def each
      while (line = parser.next_line)
        instruction = identify(line)
        @address   += 1 unless instruction.is_a?(LInstruction)
        yield(instruction)
      end
    end

    private

    def identify(line)
      case line
      when /\A@(\S+)\z/
        AInstruction.new($1)
      when /\A\(([^)]+)\)\z/
        LInstruction.new(label: $1, address: address)
      when / \A (?: (?<destinations>\w+) = )?
             (?<computation>[^;]+)
             (?: ; (?<jump>\w+) )? \z /x
        CInstruction.new(
          destinations: $~[:destinations],
          computation:  $~[:computation],
          jump:         $~[:jump]
        )
      else
        fail "Error:  unknown instruction %p" % line
      end
    end
  end
end
