module VM
  class FunctionCall

    def write_to(runtime, options = { })
      params = options.fetch(:params)
      runtime.call_function(
        function_name: params.fetch(:function_name),
        arguments:     params.fetch(:arguments)
      )
    end

  end
end
