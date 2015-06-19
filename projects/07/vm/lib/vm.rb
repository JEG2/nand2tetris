require_relative "vm/parser"
require_relative "vm/runtime"

module VM
  module_function

  def translate(vm_code_path)
    hack_code_path = vm_code_path.sub(/\.vm\z/i, ".asm")
    stack          = Runtime.new(File.basename(vm_code_path, ".vm"))
    Parser.new(File.read(vm_code_path)).parse.each do |command|
      command.write_to(stack)
    end
    open(hack_code_path, "w") do |f|
      f.puts stack
    end
  end
end
