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

    def call_function()
      @last_return += 1
      add_hack(<<-END_HACK)
      @return:#{@last_return}
      D=A
      @SP
      M=M+1
      A=M-1
      M=D

      (@return:#{@last_return})
      END_HACK
    end

    private

    def add_hack(new_lines)
      hack << new_lines
    end
  end
end
