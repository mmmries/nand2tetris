module Assembler
  class Address < Command
    attr_reader :location

    def initialize(str)
      @location = str.slice(1).to_i
      raise ArgumentError.new("Invalid memory location #{location}") unless location >= 0 && location <= 32767
    end

    def binary
      location_binary = location.to_s(2)
      ("0"*(16 - location_binary.size))+location_binary
    end
  end
end
