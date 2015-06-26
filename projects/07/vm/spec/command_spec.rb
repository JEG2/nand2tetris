require_relative "../lib/vm/command"

describe VM::Command do
  let(:command) {
    VM::Command.new(name: "test", operations: double)
  }
  let(:command_with_params) {
    VM::Command.new(
      name:       "params",
      params:     {segment: /\A(?:argument|local)\z/, index: /\A\d+\z/},
      operations: double
    )
  }

  it "tracks a name" do
    expect(command.name).to eq("test")
  end

  it "parses a command by name" do
    parsed, _ = command.parse(%w[test])
    expect(parsed).to be_an_instance_of(VM::ParameterizedCommand)
    expect(parsed.command).to eq(command)
  end

  it "parses params" do
    parsed, _ = command_with_params.parse(%w[params local 42])
    expect(parsed).to be_an_instance_of(VM::ParameterizedCommand)
    expect(parsed.params).to eq(segment: "local", index: "42")
  end

  it "returns unparsed tokens" do
    _, tokens = command.parse(%w[test])
    expect(tokens).to eq([ ])

    _, tokens = command.parse(%w[test extra tokens])
    expect(tokens).to eq(%w[extra tokens])

    _, tokens = command_with_params.parse(%w[params local 42])
    expect(tokens).to eq([ ])

    _, tokens = command_with_params.parse(%w[params local 42 extra tokens])
    expect(tokens).to eq(%w[extra tokens])
  end

  it "returns nil and the passed tokens on a failed parse" do
    parsed, tokens = command_with_params.parse(%w[params oops 42])
    expect(parsed).to be_nil
    expect(tokens).to eq(%w[params oops 42])
  end

  it "forwards writes to the operations" do
    operations = double
    command    = VM::Command.new(name: "forward", operations: operations)
    runtime    = double
    expect(operations).to receive(:write_to).with(
      runtime,
      hash_including(command: command.name)
    )
    command.write_to(runtime)
  end

  it "forwards all write options" do
    operations = double
    command    = VM::Command.new(name: "options", operations: operations)
    runtime    = double
    options    = {a: 1, b: 2}
    expect(operations).to receive(:write_to).with(
      runtime,
      hash_including(options)
    )
    command.write_to(runtime, options)
  end
end
