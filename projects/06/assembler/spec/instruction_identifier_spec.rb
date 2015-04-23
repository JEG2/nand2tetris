require_relative "spec_helper"

require_relative "../lib/assembler/instruction_identifier"

describe Assembler::InstructionIdentifier do
  def instructions_for(lines)
    parser = double
    allow(parser).to receive(:next_line).and_return(*lines, nil)
    Assembler::InstructionIdentifier.new(parser)
  end

  it "recognizes A-instructions" do
    instructions = instructions_for(%w[@42])
    expect(instructions.first).to be_an_instance_of(Assembler::AInstruction)
  end

  it "recognizes L-instructions" do
    instructions = instructions_for(%w[(loop)])
    expect(instructions.first).to be_an_instance_of(Assembler::LInstruction)
  end

  it "recognizes C-instructions" do
    instructions = instructions_for(%w[D=D+1])
    expect(instructions.first).to be_an_instance_of(Assembler::CInstruction)
  end

  it "tracks instruction addresses" do
    instructions    = instructions_for(%w[@1 (two) @2 @3 (four) D=0])
    label_addresses = instructions.grep(Assembler::LInstruction).map(&:address)
    expect(label_addresses).to eq([1, 3])
  end
end
