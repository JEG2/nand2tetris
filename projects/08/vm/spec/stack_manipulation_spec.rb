require_relative "../lib/vm/stack_manipulation"

describe VM::StackManipulation do
  let(:runtime) { TestRuntime.new(__FILE__) }

  it "loads constants" do
    subject.write_to(
      runtime,
      command: "push", params: {segment: "constant", index: 42}
    )
    expect(runtime.stack).to eq([42])
  end

  it "doesn't support pop constant" do
    expect do
      subject.write_to(
        runtime,
        command: "pop", params: {segment: "constant", index: 42}
      )
    end.to raise_error(RuntimeError)
  end

  it "reads and writes static values" do
    runtime = double(file: __FILE__)
    expect(runtime).to receive(:read).with(
      pointer: "#{__FILE__}.42", offset: 0, register: true
    )
    expect(runtime).to receive(:push)
    subject.write_to(
      runtime,
      command: "push", params: {segment: "static", index: 42}
    )

    expect(runtime).to receive(:pop)
    expect(runtime).to receive(:write).with(
      pointer: "#{__FILE__}.42", offset: 0, register: true
    )
    subject.write_to(
      runtime,
      command: "pop", params: {segment: "static", index: 42}
    )
  end

  it "reads and writes using pointers" do
    runtime.load_data(number: 2)
    runtime.push
    runtime.load_data(number: 1)
    runtime.push
    subject.write_to(
      runtime,
      command: "pop", params: {segment: "argument", index: 3}
    )
    subject.write_to(
      runtime,
      command: "pop", params: {segment: "local", index: 0}
    )

    subject.write_to(
      runtime,
      command: "push", params: {segment: "argument", index: 3}
    )
    subject.write_to(
      runtime,
      command: "push", params: {segment: "local", index: 0}
    )
    expect(runtime.stack).to eq([1, 2])
  end

  it "reads and writes using registers" do
    runtime.load_data(number: 2)
    runtime.push
    subject.write_to(
      runtime,
      command: "pop", params: {segment: "temp", index: 1}
    )

    2.times do
      subject.write_to(
        runtime,
        command: "push", params: {segment: "temp", index: 1}
      )
    end
    expect(runtime.stack).to eq([2, 2])
  end

  it "rejects pointer manipulations above 1" do
    expect do
      subject.write_to(
        runtime,
        command: "push", params: {segment: "pointer", index: 42}
      )
    end.to raise_error(RuntimeError)
  end

  it "fails for unknown segments" do
    expect do
      subject.write_to(
        runtime,
        command: "push", params: {segment: "oops", index: 42}
      )
    end.to raise_error(RuntimeError)
  end
end
