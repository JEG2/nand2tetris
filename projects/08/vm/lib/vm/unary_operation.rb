module VM
  class UnaryOperation
    def initialize(operator)
      @operator = operator
    end

    attr_reader :operator
    private     :operator

    def write_to(runtime, **options)
      runtime.pop(expression: "#{operator}M")
      runtime.push
    end
  end
end
