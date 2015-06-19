module VM
  class BinaryOperation
    def initialize(operator)
      @operator = operator
    end

    attr_reader :operator
    private     :operator

    def write_to(runtime, options = { })
      runtime.pop(:right)
      runtime.pop(:left)
      operator.write_to(runtime, has_left: true)
      runtime.push(:result)
    end
  end
end
