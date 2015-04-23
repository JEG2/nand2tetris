module Assembler
  class LInstruction
    def initialize(label: , address: )
      @label   = label
      @address = address
    end

    attr_reader :label, :address
  end
end
