module VM
  class BinaryOperation
    def initialize(operator)
      @operator = operator
    end

    attr_reader :operator
    private     :operator

    def write_to(runtime, options = { })
      runtime.pop
      runtime.pop(expression: operator == :- ? "M-D" : "D#{operator}M")
      runtime.push
    end
  end
end
