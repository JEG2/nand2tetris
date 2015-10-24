module VM
  class BootstrapOperation

    def write_to(runtime, **options)
      runtime.load_data(number: 256)
      runtime.update_pointer(name: "SP")
      runtime.call_function(function_name: "Sys.init", arguments: 0)
    end

  end
end
