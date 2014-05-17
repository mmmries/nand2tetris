module Assembler
  class Address < Command
    DIGITS = %w(0 1 2 3 4 5 6 7 8 9 0)

    attr_reader :location, :symbol

    def initialize(str)
      if DIGITS.include?(str[1])
        @location = str[1..-1].to_i
        verify_location
      else
        @symbol = str[1..-1]
      end
    end

    def binary
      location_binary = location.to_s(2)
      ("0"*(16 - location_binary.size))+location_binary
    end

    def resolve(table)
      return true if @location
      @location = table.fetch(symbol)
      verify_location
    end

    def verify_location
      raise ArgumentError.new("Invalid memory location #{location}") unless location >= 0 && location <= 32767
    end
  end
end
