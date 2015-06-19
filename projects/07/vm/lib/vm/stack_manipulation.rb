module VM
  class StackManipulation
    def write_to(runtime, options = { })
      case options[:params][:segment]
      when "argument"
        dispatch_to(runtime, options[:command], "ARG", options[:params][:index])
      when "local"
        dispatch_to(runtime, options[:command], "LCL", options[:params][:index])
      when "static"
        static = "#{runtime.file}.#{options[:params][:index]}"
        runtime.send(options[:command], static)
      when "constant"
        runtime.send(options[:command], options[:params][:index], as: "A")
      when "this"
        dispatch_to(runtime, options[:command], "THIS", options[:params][:index])
      when "that"
        dispatch_to(runtime, options[:command], "THAT", options[:params][:index])
      when "pointer"
        dispatch_to_register(
          runtime,
          options[:command],
          3 + options[:params][:index].to_i
        )
      when "temp"
        dispatch_to_register(
          runtime,
          options[:command],
          5 + options[:params][:index].to_i
        )
      end
    end

    private

    def dispatch_to(runtime, command, pointer, offset)
      send("#{command}_to", runtime, pointer, offset)
    end

    def push_to(runtime, pointer, offset)
      runtime.read(pointer, offset, :value)
      runtime.push(:value)
    end

    def pop_to(runtime, pointer, offset)
      runtime.pop(:value)
      runtime.write(pointer, offset, :value)
    end

    def dispatch_to_register(runtime, command, number)
      runtime.send(command, "R#{number}")
    end
  end
end
