require_relative "l_instruction"
require_relative "instruction_identifier"
require_relative "parser"

module Assembler
  class Converter
    DEFAULT_SYMBOLS = {
      "SP"     => 0,
      "LCL"    => 1,
      "ARG"    => 2,
      "THIS"   => 3,
      "THAT"   => 4,
      "SCREEN" => 16_384,
      "KBD"    => 24_576
    }.tap do |symbols|
      16.times do |n|
        symbols["R#{n}"] = n
      end
    end

    def initialize(path)
      @path          = path
      @symbolic      = File.read(path)
      @symbol_table  = DEFAULT_SYMBOLS.dup
      @next_variable = 16
    end

    attr_reader :path, :symbolic, :symbol_table
    private     :path, :symbolic, :symbol_table

    def to_bits
      build_symbol_table
      generate_bits
    end

    def convert
      fail "Error:  expected .asm file" unless path =~ /\.asm\z/

      open(path.sub(/\.asm\z/, ".hack"), "w") do |hack|
        hack.write(to_bits)
      end
    end

    private

    def build_symbol_table
      instructions.grep(LInstruction).each do |instruction|
        symbol_table[instruction.label] = instruction.address
      end
    end

    def generate_bits
      instructions.inject("") { |bits, instruction|
        if instruction.respond_to?(:address?) &&
           !instruction.address?              &&
           !symbol_table.include?(instruction.label)
          symbol_table[instruction.label] = @next_variable
          @next_variable                 += 1
        end

        if instruction.respond_to?(:to_bits)
          "#{bits}#{instruction.to_bits(symbol_table)}\n"
        else
          bits
        end
      }
    end

    def instructions
      InstructionIdentifier.new(Parser.new(symbolic))
    end
  end
end
