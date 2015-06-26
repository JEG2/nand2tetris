module VM
  class StackManipulation
    SEGMENT_POINTERS = {
      "argument" => "ARG",
      "local"    => "LCL",
      "this"     => "THIS",
      "that"     => "THAT",
      "pointer"  => "R3",
      "temp"     => "R5"
    }

    def write_to(runtime, **options)
      case (segment = options[:params][:segment])
      when "constant"
        if options[:command] == "push"
          runtime.load_data(number: options[:params][:index])
          runtime.push
        else
          fail "Not supported:  pop constant"
        end
      when "static"
        dispatch_to(
          "#{runtime.file}.#{options[:params][:index]}",
          runtime,
          options
        )
      else
        if SEGMENT_POINTERS.include?(segment)
          if segment == "pointer" && options[:params][:index] !~ /\A[01]\z/
            fail "Not supported:  pointer index #{options[:params][:index]}"
          end
          dispatch_to(SEGMENT_POINTERS[segment], runtime, options)
        else
          fail "Unknown segment:  #{segment}"
        end
      end
    end

    private

    def dispatch_to(pointer, runtime, options)
      command  = options[:command]
      offset   = pointer.include?(".") ? 0 : options[:params][:index]
      register = pointer.start_with?("R") || pointer.include?(".")
      send("#{command}_to", runtime, pointer, offset, register)
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
