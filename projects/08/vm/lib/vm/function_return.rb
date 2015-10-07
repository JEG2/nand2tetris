module VM
  class FunctionReturn

    def write_to(runtime, options = {})
      runtime.return_from_function
    end

  end
end
