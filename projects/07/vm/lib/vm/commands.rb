require_relative "command"
require_relative "binary_operation"
require_relative "unary_operation"
require_relative "conditional"
require_relative "stack_manipulation"
require_relative "labeler"
require_relative "goto"
require_relative "function_definition"
require_relative "function_call"

module VM
  SEGMENTS = %w[argument local static constant this that pointer temp]

  class FailedParseCommand
    def parse(tokens)
      fail "Cannot parse #{tokens.inspect}"
    end
  end

  COMMANDS = [
    Command.new(
      name:       "add",
      operations: BinaryOperation.new(:+)
    ),
    Command.new(
      name:       "sub",
      operations: BinaryOperation.new(:-)
    ),
    Command.new(
      name:       "neg",
      operations: UnaryOperation.new(:-)
    ),
    Command.new(
      name:       "eq",
      operations: Conditional.new(:EQ)
    ),
    Command.new(
      name:       "lt",
      operations: Conditional.new(:LT)
    ),
    Command.new(
      name:       "gt",
      operations: Conditional.new(:GT)
    ),
    Command.new(
      name:       "and",
      operations: BinaryOperation.new(:&)
    ),
    Command.new(
      name:       "or",
      operations: BinaryOperation.new(:|)
    ),
    Command.new(
      name:       "not",
      operations: UnaryOperation.new(:!)
    ),
    Command.new(
      name:       "push",
      params:     {
        segment: ->(arg) { SEGMENTS.include?(arg) },
        index:   /\A\d+\z/
      },
      operations: StackManipulation.new
    ),
    Command.new(
      name:       "pop",
      params:     {
        segment: ->(arg) { SEGMENTS.include?(arg) },
        index:   /\A\d+\z/
      },
      operations: StackManipulation.new
    ),
    Command.new(
      name: "label",
      params: {
        label_name: /\A[a-zA-Z._:][\w.:]*\z/
      },
      operations: Labeler.new
    ),
    Command.new(
      name: "goto",
      params: {
        label_name: /\A[a-zA-Z._:][\w.:]*\z/
      },
      operations: Goto.new
    ),
    Command.new(
      name: "if-goto",
      params: {
        label_name: /\A[a-zA-Z._:][\w.:]*\z/
      },
      operations: Goto.new(conditional: true)
    ),
    Command.new(
      name: "function",
      params: {
        function_name: /\A[a-zA-Z._:][\w.:]*\z/,
        locals: /\A\d+\Z/,
      },
      operations: FunctionDefinition.new
    ),
    Command.new(
      name: "call",
      params: {
        function_name: /\A[a-zA-Z._:][\w.:]*\z/,
        arguments: /\A\d+\Z/,
      },
      operations: FunctionCall.new
    ),
    FailedParseCommand.new
  ]
end
