require_relative "../lib/vm/unary_operation"

describe VM::UnaryOperation do
  let(:runtime) { TestRuntime.new(__FILE__) }

  it "pops an operand, calculates, and pushes the result" do
    runtime.load_data(number: 13)
    runtime.push
    VM::UnaryOperation.new(:-).write_to(runtime)
    expect(runtime.stack).to eq([-13])
  end

  it "honors the passed operator" do
    runtime.load_data(number: 42)
    runtime.push
    VM::UnaryOperation.new(:!).write_to(runtime)
    expect(runtime.stack).to eq([false])
  end
end
