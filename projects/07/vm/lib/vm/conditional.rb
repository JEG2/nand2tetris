module VM
  class Conditional
    def initialize(test)
      @test = test
    end

    attr_reader :test
    private     :test

    def write_to(runtime, options = { })
      runtime.pop(:right)
      runtime.pop(:left)
      runtime.operation(:left, :-, :right, :condition)
      runtime.jump(:condition, test)
    end
  end
end
