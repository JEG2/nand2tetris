module VM
  class UnaryOperation
    def initialize(operator)
      @operator = operator
    end

    attr_reader :operator
    private     :operator

    def write_to(runtime, options = { })
      runtime.pop(:right)
      operator.write_to(runtime, has_left: false)
      runtime.push(:result)
    end
  end
end
