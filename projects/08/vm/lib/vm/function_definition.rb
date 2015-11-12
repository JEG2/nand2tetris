module VM
  class FunctionDefinition

    def write_to(runtime, options = { })
      function_name = options.fetch(:params).fetch(:function_name)
      runtime.create_label(function_name)
      runtime.current_function_name = function_name

      local_count = options.fetch(:params).fetch(:locals)
      Integer(local_count).times do
        runtime.load_data(number: 0)
        runtime.push
      end
    end

  end
end
