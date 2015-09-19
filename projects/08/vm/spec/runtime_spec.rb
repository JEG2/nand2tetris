require_relative "../lib/vm/runtime"

describe VM::Runtime do
  let(:runtime) { VM::Runtime.new(__FILE__) }

  it "accumulates commands as they are entered" do
    runtime.load_data(number: 42)
    shorter = runtime.to_s
    runtime.push
    longer  = runtime.to_s
    expect(shorter.size).to be < longer.size
  end

  it "adds the hack code to end a program" do
    expect(runtime.to_s).to match(/\(END\)\s+@END\s+0;JMP\s*\z/)
  end

  it "outdents labels" do
    hack = runtime.to_s
    expect(hack).to match(/^\(/)
    expect(hack).to match(/^\s{2}[^(]/)
  end
end
