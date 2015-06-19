require_relative "../lib/vm/parser"

describe VM::Parser do
  it "parses vm code into commands" do
    commands = VM::Parser.new("push argument 0\nnot").parse
    expect(commands.size).to       eq(2)
    expect(commands.first.name).to eq("push")
    expect(commands.last.name).to  eq("not")
  end

  it "ignores comments" do
    commands = VM::Parser.new("// full line\nNOT // partial line").parse
    expect(commands.size).to       eq(1)
    expect(commands.first.name).to eq("not")
  end

  it "ignores case" do
    commands = VM::Parser.new("NOT").parse
    expect(commands.size).to       eq(1)
    expect(commands.first.name).to eq("not")
  end

  it "raises an error for unrecognized tokens" do
    parser = VM::Parser.new("UNRECOGNIZEDTOKEN")
    expect do
      parser.parse
    end.to raise_error
  end
end
