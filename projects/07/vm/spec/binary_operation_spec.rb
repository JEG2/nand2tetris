require_relative "../lib/vm/binary_operation"

describe VM::BinaryOperation do
  let(:runtime) { TestRuntime.new(__FILE__) }

  it "pops operands, calculates, and pushes results" do
    runtime.load_data(number: 40)
    runtime.push
    runtime.load_data(number: 2)
    runtime.push
    VM::BinaryOperation.new(:+).write_to(runtime)
    expect(runtime.stack).to eq([42])
  end

  it "honors the passed operator" do
    runtime.load_data(number: 2)
    runtime.push
    runtime.load_data(number: 1)
    runtime.push
    VM::BinaryOperation.new(:|).write_to(runtime)
    expect(runtime.stack).to eq([3])
  end

  it "is careful with operand order for subtraction" do
    runtime = double
    expect(runtime).to receive(:pop)
    expect(runtime).to receive(:pop).with(expression: "M-D")
    expect(runtime).to receive(:push)
    VM::BinaryOperation.new(:-).write_to(runtime)
  end
end
