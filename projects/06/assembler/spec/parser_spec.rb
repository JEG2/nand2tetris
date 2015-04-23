require_relative "spec_helper"

require_relative "../lib/assembler/parser"

describe Assembler::Parser do
  it "removes newlines off of read lines" do
    parser = Assembler::Parser.new("line\n")
    expect(parser.next_line).to eq("line")
  end

  it "returns lines of input in order" do
    parser = Assembler::Parser.new("one\ntwo")
    expect(parser.next_line).to eq("one")
    expect(parser.next_line).to eq("two")
  end

  it "returns nil when there are no more lines" do
    parser = Assembler::Parser.new("")
    expect(parser.next_line).to be_nil
  end

  it "ignores whitespace" do
    parser = Assembler::Parser.new("  A D\t=\t D + 1  \n\n  \n0 ; JEQ\n")
    expect(parser.next_line).to eq("AD=D+1")
    expect(parser.next_line).to eq("0;JEQ")
  end

  it "strips comments" do
    parser = Assembler::Parser.new("D=0 // ignore this\n// and this\nD=D+1")
    expect(parser.next_line).to eq("D=0")
    expect(parser.next_line).to eq("D=D+1")
  end
end
