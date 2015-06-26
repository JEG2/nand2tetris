require_relative "../lib/vm/parameterized_command"

describe VM::ParameterizedCommand do
  it "forwards name to the command" do
    command = double(name: "test")
    wrapped = VM::ParameterizedCommand.new(params: { }, command: command)
    expect(wrapped.name).to eq(command.name)
  end

  it "forwards writes to the command with params" do
    command = double
    params  = double
    wrapped = VM::ParameterizedCommand.new(params: params, command: command)
    runtime = double
    expect(command).to receive(:write_to).with(
      runtime,
      hash_including(params: params)
    )
    wrapped.write_to(runtime)
  end
end
