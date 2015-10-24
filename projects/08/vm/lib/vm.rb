require_relative "vm/parser"
require_relative "vm/runtime"
require_relative "vm/bootstrap_operation"

module VM
  module_function

  def translate(vm_code_path)
    if File.directory?(vm_code_path)
      bootstrap_runtime = Runtime.new
      BootstrapOperation.new.write_to(bootstrap_runtime)
      asm_buffer = bootstrap_runtime.to_s

      Dir.glob(File.join(vm_code_path, "**/*.vm")) { |file|
        stack = Runtime.new(File.basename(file, ".vm"))
        Parser.new(File.read(file)).parse.each do |command|
          command.write_to(stack)
        end
        asm_buffer << stack.to_s
      }

      target_file_name = File.basename(vm_code_path) + ".asm"
      File.open(File.join(vm_code_path, target_file_name), "w") { |f|
        f.write(asm_buffer)
      }
    else
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
end
