module VM
  class Labeler

    def write_to(runtime, options = { })
      runtime.create_scoped_label(options.fetch(:params).fetch(:label_name))
    end

  end
end
