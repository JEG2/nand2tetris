module VM
  class FunctionDefinition

    def write_to(runtime, options = { })
      runtime.create_label(options.fetch(:params).fetch(:function_name))

      local_count = options.fetch(:params).fetch(:locals)
      Integer(local_count).times do
        runtime.load_data(number: 0)
        runtime.push
      end
    end

  end
end
