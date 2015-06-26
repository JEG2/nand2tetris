module VM
  class StackManipulation
    def write_to(runtime, options = { })
      case options[:params][:segment]
      when "argument"
        dispatch_to(runtime, options[:command], "ARG", options[:params][:index])
      when "local"
        dispatch_to(runtime, options[:command], "LCL", options[:params][:index])
      when "static"
        dispatch_to(runtime, options[:command], "#{runtime.file}.#{options[:params][:index]}", 0)
      when "constant"
        if options[:command] == "push"
          runtime.load_data(number: options[:params][:index])
          runtime.push
        else
          fail "pop constant not supported"
        end
      when "this"
        dispatch_to(runtime, options[:command], "THIS", options[:params][:index])
      when "that"
        dispatch_to(runtime, options[:command], "THAT", options[:params][:index])
      when "pointer"
        dispatch_to(runtime, options[:command], "R3", options[:params][:index])
      when "temp"
        dispatch_to(runtime, options[:command], "R5", options[:params][:index])
      end
    end

    private

    def dispatch_to(runtime, command, pointer, offset)
      send("#{command}_to", runtime, pointer, offset, pointer.start_with?("R") || pointer.include?("."))
    end

    def push_to(runtime, pointer, offset, register)
      runtime.read(pointer: pointer, offset: offset, register: register)
      runtime.push
    end

    def pop_to(runtime, pointer, offset, register)
      runtime.pop
      runtime.write(pointer: pointer, offset: offset, register: register)
    end
  end
end
