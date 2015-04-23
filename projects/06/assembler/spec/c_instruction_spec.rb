require_relative "spec_helper"

require_relative "../lib/assembler/c_instruction"

describe Assembler::CInstruction do
  it "begins with the C-instruction indicator" do
    instruction = Assembler::CInstruction.new(computation: "0")
    expect(instruction.to_bits).to match(/\A1/)
  end

  it "defaults the 'a' bit to off" do
    instruction = Assembler::CInstruction.new(computation: "0")
    expect(instruction.to_bits).to match(/\A.{3}0/)
  end

  it "sets the 'a' bit when M is used" do
    instruction = Assembler::CInstruction.new(computation: "M")
    expect(instruction.to_bits).to match(/\A.{3}1/)
  end

  it "encodes the 'dest' bits" do
    instruction = Assembler::CInstruction.new(
      destinations: "AD",
      computation:  "0"
    )
    expect(instruction.to_bits).to match(/\A.{10}110/)
  end

  it "encodes the 'jump' bits" do
    instruction = Assembler::CInstruction.new(computation: "0", jump: "JNE")
    expect(instruction.to_bits).to match(/\A.{13}101/)
  end
end
