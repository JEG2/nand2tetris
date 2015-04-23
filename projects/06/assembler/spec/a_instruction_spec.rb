require_relative "spec_helper"

require_relative "../lib/assembler/a_instruction"

describe Assembler::AInstruction do
  it "recognizes addresses" do
    instruction = Assembler::AInstruction.new("42")
    expect(instruction).to be_address
  end

  it "recognizes labels" do
    instruction = Assembler::AInstruction.new("R3")
    expect(instruction).not_to be_address
  end

  it "converts addresses" do
    instruction = Assembler::AInstruction.new("42")
    expect(instruction.address).to eq(42)
  end

  it "tracks labels" do
    instruction = Assembler::AInstruction.new("R3")
    expect(instruction.label).to eq("R3")
  end

  it "converts address instructions to bits" do
    instruction = Assembler::AInstruction.new("42")
    expect(instruction.to_bits).to eq("0000000000101010")
  end

  it "converts label instructions to bits" do
    instruction = Assembler::AInstruction.new("R3")
    expect(instruction.to_bits("R3" => 3)).to eq("0000000000000011")
  end
end
