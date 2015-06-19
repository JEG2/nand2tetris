module VM
  class Operator
    def initialize(operator)
      @operator = operator
    end

    attr_reader :operator
    private     :operator

    def write_to(runtime, options = { })
      left = options[:has_left] ? :left : nil
      runtime.operation(left, operator, :right, :result)
    end
  end
end
