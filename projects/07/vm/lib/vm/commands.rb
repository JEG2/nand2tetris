require_relative "command"
require_relative "binary_operation"
require_relative "unary_operation"
require_relative "conditional"
require_relative "stack_manipulation"

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
    FailedParseCommand.new
  ]
end
