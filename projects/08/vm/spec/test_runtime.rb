class TestRuntime
  COMPARISONS = {EQ: :==, LT: :<, GT: :>}

  def initialize(_)
    @stack     = [ ]
    @d         = nil
    @pointers  = Hash.new { |name, values| name[values] = [ ] }
    @registers = [ ]
  end

  attr_reader :stack, :d, :pointers, :registers

  def push
    stack << d
  end

  def pop(expression: "M")
    @d =
      case expression
      when /\AM\z/     then stack.pop
      when /\AM-D\z/   then stack.pop - d
      when /\AD(.)M\z/ then d.public_send($1, stack.pop)
      when /\A(.)M\z/  then eval("#{$1}#{stack.pop.inspect}")
      else                  fail "Unexpected expression:  #{expression}"
      end
  end

  def load_data(number: )
    @d = number
  end

  def read(pointer: , offset: , register: )
    target = register ? registers : pointers
    @d     = target[offset]
  end

  def write(pointer: , offset: , register: )
    target         = register ? registers : pointers
    target[offset] = d
  end

  def jump(comparison: )
    @d = d.public_send(COMPARISONS[comparison], 0)
    push
  end
end
