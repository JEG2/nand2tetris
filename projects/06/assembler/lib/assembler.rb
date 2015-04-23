require_relative "assembler/converter"

module Assembler
  module_function

  def assemble(*args)
    Converter.new(*args).convert
  end
end
