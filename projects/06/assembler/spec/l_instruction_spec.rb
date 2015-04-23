require_relative "spec_helper"

require_relative "../lib/assembler/l_instruction"

describe Assembler::LInstruction do
  it "tracks a label" do
    instruction = Assembler::LInstruction.new(label: "label", address: 42)
    expect(instruction.label).to eq("label")
  end

  it "tracks an address" do
    instruction = Assembler::LInstruction.new(label: "label", address: 42)
    expect(instruction.address).to eq(42)
  end
end
