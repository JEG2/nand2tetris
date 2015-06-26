module VM
  class Conditional
    def initialize(comparison)
      @comparison = comparison
    end

    attr_reader :comparison
    private     :comparison

    def write_to(runtime, options = { })
      runtime.pop
      runtime.pop(expression: "M-D")
      runtime.jump(comparison: comparison)
    end
  end
end
