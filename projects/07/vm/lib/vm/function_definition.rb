module VM
  class FunctionDefinition

    def write_to(runtime, options = { })
      runtime.create_label(options.fetch(:params).fetch(:function_name))

      local_count = options.fetch(:params).fetch(:locals)
      local_count.times do
        runtime.push(0, as: "A")
      end
    end

  end
end
