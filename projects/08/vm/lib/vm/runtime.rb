module VM
  class Runtime
    def initialize(file)
      @file             = file
      @hack             = ""
      @last_conditional = 0
      @last_return      = 0
    end

    attr_reader :file

    attr_reader :hack
    private     :hack

    def push
      add_hack(<<-END_HACK)
      @SP
      M=M+1
      A=M-1
      M=D
      END_HACK
    end

    def pop(expression: "M")
      add_hack(<<-END_HACK)
      @SP
      M=M-1
      A=M
      D=#{expression}
      END_HACK
    end

    def load_data(number: )
      add_hack(<<-END_HACK)
      @#{number}
      D=A
      END_HACK
    end

    def read(pointer: , offset: , register: )
      add_hack(<<-END_HACK)
      @#{offset}
      D=A
      @#{pointer}
      A=D+#{register ? "A" : "M"}
      D=M
      END_HACK
    end

    def write(pointer: , offset: , register: )
      add_hack(<<-END_HACK)
      @write_data
      M=D
      @#{offset}
      D=A
      @#{pointer}
      D=D+#{register ? "A" : "M"}
      @write_address
      M=D
      @write_data
      D=M
      @write_address
      A=M
      M=D
      END_HACK
    end

    def jump(comparison: )
      @last_conditional += 1
      add_hack(<<-END_HACK)
      @CONDITIONAL_#{@last_conditional}:TRUE
      D;J#{comparison}
      D=0
      @CONDITIONAL_#{@last_conditional}:FINISH
      0;JMP
      (CONDITIONAL_#{@last_conditional}:TRUE)
        D=-1
      (CONDITIONAL_#{@last_conditional}:FINISH)
        @SP
        M=M+1
        A=M-1
        M=D
      END_HACK
    end

    def create_label(name)
      add_hack(<<-END_HACK)
      (label:#{name})
      END_HACK
    end

    def to_s
      (hack + <<-END_HACK).gsub(/^\s+(\(?)/) { "#{'  ' if $1 != '('}#{$1}" }
      (END)
        @END
        0;JMP
      END_HACK
    end

    def jump_to_label(condition, label)
      add_hack(<<-END_HACK)
      @label:#{label}
      D;J#{condition}
      END_HACK
    end

    def  call_function(function_name:, arguments:)
      @last_return += 1
      add_hack(<<-END_HACK)
      @return:#{@last_return}
      D=A
      @SP
      M=M+1
      A=M-1
      M=D

      @LCL
      D=M
      @SP
      M=M+1
      A=M-1
      M=D

      @ARG
      D=M
      @SP
      M=M+1
      A=M-1
      M=D

      @THIS
      D=M
      @SP
      M=M+1
      A=M-1
      M=D

      @THAT
      D=M
      @SP
      M=M+1
      A=M-1
      M=D

      @SP
      D=M
      @5
      D=D-A
      @#{arguments}
      D=D-A
      @ARG
      M=D

      @SP
      D=M
      @LCL
      M=D

      @#{generate_function_label(function_name)}
      0;JMP

      (return:#{@last_return})
      END_HACK
    end

    def return_from_function
      add_hack(<<-END_HACK)

      @LCL
      D=M
      @RETURN_FRAME
      M=D

      @5
      A=D-A
      D=M
      @RETURN_ADDRESS
      M=D

      @SP
      M=M-1
      A=M
      D=M
      @ARG
      A=M
      M=D

      @ARG
      D=M+1
      @SP
      M=D

      @RETURN_FRAME
      D=M
      @1
      A=D-A
      D=M
      @THAT
      M=D

      @RETURN_FRAME
      D=M
      @2
      A=D-A
      D=M
      @THIS
      M=D

      @RETURN_FRAME
      D=M
      @3
      A=D-A
      D=M
      @ARG
      M=D

      @RETURN_FRAME
      D=M
      @4
      A=D-A
      D=M
      @LCL
      M=D

      @RETURN_ADDRESS
      A=M
      0;JMP
      END_HACK
    end

    private

    def add_hack(new_lines)
      hack << new_lines
    end

    def generate_function_label(function_name)
      "label:#{function_name}"
    end
  end
end
