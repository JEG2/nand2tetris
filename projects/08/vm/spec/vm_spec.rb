require "tempfile"

require_relative "../lib/vm"

describe VM::BinaryOperation do
  before do
    @vm_file = Tempfile.new(%w[add .vm])
    @vm_file.puts "push constant 40"
    @vm_file.puts "push constant 2"
    @vm_file.puts "add"
    @vm_file.fsync

    @asm_path = File.join(
      File.dirname(@vm_file.path),
      File.basename(@vm_file.path, ".vm") + ".asm"
    )
  end

  after do
    @vm_file.close
    @vm_file.unlink
    File.unlink(@asm_path) if File.exist?(@asm_path)
  end

  it "translates VM code to assembly" do
    VM.translate(@vm_file.path)
    expect(File.exist?(@asm_path)).to be_truthy
    asm = File.read(@asm_path)
    expect(asm).to include("@40")
    expect(asm).to include("@2")
  end
end
