module Assembler
  class CInstruction
    COMP = {
      "0"   => "101010",
      "1"   => "111111",
      "-1"  => "111010",
      "D"   => "001100",
      "A"   => "110000",
      "!D"  => "001101",
      "!A"  => "110001",
      "-D"  => "001111",
      "-A"  => "110011",
      "D+1" => "011111",
      "A+1" => "110111",
      "D-1" => "001110",
      "A-1" => "110010",
      "D+A" => "000010",
      "D-A" => "010011",
      "A-D" => "000111",
      "D&A" => "000000",
      "D|A" => "010101",
      "M"   => "110000",
      "!M"  => "110001",
      "-M"  => "110011",
      "M+1" => "110111",
      "M-1" => "110010",
      "D+M" => "000010",
      "D-M" => "010011",
      "M-D" => "000111",
      "D&M" => "000000",
      "D|M" => "010101"
    }
    JUMP = {
      nil   => "000",
      "JGT" => "001",
      "JEQ" => "010",
      "JGE" => "011",
      "JLT" => "100",
      "JNE" => "101",
      "JLE" => "110",
      "JMP" => "111"
    }

    def initialize(destinations: nil, computation: , jump: nil)
      @destinations = destinations
      @computation  = computation
      @jump         = jump
    end

    attr_reader :destinations, :computation, :jump
    private     :destinations, :computation, :jump

    def to_bits(_ = { })
      "111#{a_bit}#{comp_bits}#{dest_bits}#{jump_bits}"
    end

    private

    def a_bit
      computation.include?("M") ? 1 : 0
    end

    def comp_bits
      COMP.fetch(computation)
    end

    def dest_bits
      d = destinations.to_s
      [ d.include?('A') ? 1 : 0,
        d.include?('D') ? 1 : 0,
        d.include?('M') ? 1 : 0 ].join
    end

    def jump_bits
      JUMP.fetch(jump)
    end
  end
end
