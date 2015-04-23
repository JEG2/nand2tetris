module Assembler
  class AInstruction
    def initialize(address_or_label)
      @address_or_label = address_or_label
    end

    attr_reader :address_or_label
    private     :address_or_label

    def address?
      address_or_label =~ /\A\d+\z/
    end

    def address
      fail "Error:  not an address %p" % address_or_label unless address?

      address_or_label.to_i
    end

    def label
      fail "Error:  not a label %p" % address_or_label if address?

      address_or_label
    end

    def to_bits(symbol_table = { })
      "%016b" % (address? ? address : symbol_table.fetch(label))
    end
  end
end
