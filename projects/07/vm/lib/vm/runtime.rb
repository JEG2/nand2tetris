module VM
  class Runtime
    def initialize(file)
      @file             = file
      @hack             = ""
      @last_conditional = 0
    end

    attr_reader :file

    attr_reader :hack
    private     :hack

    def pop(variable)
      add_hack(<<-END_HACK)
      @SP
      M=M-1
      A=M
      D=M
      @#{variable}
      M=D
      END_HACK
    end

    def push(variable, as: "M")
      add_hack(<<-END_HACK)
      @#{variable}
      D=#{as}
      @SP
      M=M+1
      A=M-1
      M=D
      END_HACK
    end

    def read(pointer, offset, variable)
      add_hack(<<-END_HACK)
      @#{offset}
      D=A
      @#{pointer}
      A=M+D
      D=M
      @#{variable}
      M=D
      END_HACK
    end

    def write(pointer, offset, variable)
      add_hack(<<-END_HACK)
      @#{offset}
      D=A
      @#{pointer}
      D=M+D
      @write_address
      M=D
      @#{variable}
      D=M
      @write_address
      A=M
      M=D
      END_HACK
    end

    def operation(left, op, right, result)
      add_hack((left ? <<-END_LEFT : "") + <<-END_HACK)
      @#{left}
      D=M
      @#{result}
      M=D
      END_LEFT
      @#{right}
      D=M
      @#{result}
      M=#{'M' if left}#{op}D
      END_HACK
    end

    def jump(variable, condition)
      @last_conditional += 1
      add_hack(<<-END_HACK)
      @#{variable}
      D=M
      @TRUE#{@last_conditional}
      D;J#{condition}
      @SP
      M=M+1
      A=M-1
      M=0
      @DONE#{@last_conditional}
      0;JMP
      (TRUE#{@last_conditional})
        @SP
        M=M+1
        A=M-1
        M=-1
      (DONE#{@last_conditional})
      END_HACK
    end

    def to_s
      (hack + <<-END_HACK).gsub(/^\s+/, "")
      (END)
        @END
        0;JMP
      END_HACK
    end

    private

    def add_hack(new_lines)
      hack << new_lines
    end
  end
end
