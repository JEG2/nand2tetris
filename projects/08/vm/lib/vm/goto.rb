module VM
  class Goto
    attr_reader :conditional
    private     :conditional

    def initialize(conditional: false)
      @conditional = conditional
    end

    def write_to(runtime, options = { })
      if conditional
        runtime.pop
      else
        runtime.load_data(number: 1)
      end

      runtime.jump_to_label("NE", options.fetch(:params).fetch(:label_name))
    end

  end
end
