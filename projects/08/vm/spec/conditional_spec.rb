require_relative "../lib/vm/conditional"

describe VM::Conditional do
  let(:runtime) { TestRuntime.new(__FILE__) }

  it "pops operands, compares, and pushes the result" do
    runtime.load_data(number: 40)
    runtime.push
    runtime.load_data(number: 2)
    runtime.push
    VM::Conditional.new(:GT).write_to(runtime)
    expect(runtime.stack).to eq([true])
  end

  it "honors the passed comparison" do
    runtime.load_data(number: 40)
    runtime.push
    runtime.load_data(number: 2)
    runtime.push
    VM::Conditional.new(:EQ).write_to(runtime)
    expect(runtime.stack).to eq([false])
  end
end
