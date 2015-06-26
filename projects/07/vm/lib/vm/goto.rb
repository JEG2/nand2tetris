module VM
  class Goto
    attr_reader :conditional
    private     :conditional

    def initialize(conditional: false)
      @conditional = conditional
    end

    def write_to(runtime, options = { })
      runtime.push(1, as: "A") if !conditional
      runtime.pop(:condition)
      runtime.jump_to_label(:condition, "NE", options.fetch(:params).fetch(:label_name))
    end

  end
end
