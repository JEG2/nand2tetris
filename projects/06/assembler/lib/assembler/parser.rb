require "strscan"

module Assembler
  class Parser
    def initialize(input)
      @scanner = StringScanner.new(input)
    end

    attr_reader :scanner
    private     :scanner

    def next_line
      line = ""

      loop do
        scanner.scan(%r{[^\S\n]+})
        scanner.scan(%r{//.*})

        break if scanner.eos?
        break if scanner.scan(/\n/) && !line.empty?

        if (chunk = scanner.scan(%r{[^\s/]+}))
          line << chunk
        end
      end

      line.empty? ? nil : line
    end
  end
end
