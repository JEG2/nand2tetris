require_relative "spec_helper"

require "tempfile"

require_relative "../lib/assembler/converter"

describe Assembler::Converter do
  SYMBOLIC = <<-END_SYMBOLIC
      @i
      M=1
      @sum
      M=0
  (LOOP)
      @i
      D=M
      @100
      D=D-A
      @END
      D;JGT
      @i
      D=M
      @sum
      M=D+M
      @i
      M=M+1
      @LOOP
      0;JMP
  (END)
      @END
      0;JMP
  END_SYMBOLIC
  BITS     = <<-END_BITS.gsub(/^\s+/, "")
  0000000000010000
  1110111111001000
  0000000000010001
  1110101010001000
  0000000000010000
  1111110000010000
  0000000001100100
  1110010011010000
  0000000000010010
  1110001100000001
  0000000000010000
  1111110000010000
  0000000000010001
  1111000010001000
  0000000000010000
  1111110111001000
  0000000000000100
  1110101010000111
  0000000000010010
  1110101010000111
  END_BITS

  before :all do
    @asm = Tempfile.new("prog.asm").tap do |f|
      f.write(SYMBOLIC)
      f.rewind
    end
  end

  after :all do
    @asm.close
    @asm.unlink
  end

  it "transforms symbolic commands into bits" do
    converter = Assembler::Converter.new(@asm.path)
    expect(converter.to_bits).to eq(BITS)
  end
end
