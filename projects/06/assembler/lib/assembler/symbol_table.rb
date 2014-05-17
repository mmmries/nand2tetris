module Assembler
  class SymbolTable
    def initialize
      @table = {
        "SP"     => 0,
        "LCL"    => 1,
        "ARG"    => 2,
        "THIS"   => 3,
        "THAT"   => 4,
        "R0"     => 0,
        "R1"     => 1,
        "R2"     => 2,
        "R3"     => 3,
        "R4"     => 4,
        "R5"     => 5,
        "R6"     => 6,
        "R7"     => 7,
        "R8"     => 8,
        "R9"     => 9,
        "R10"    => 10,
        "R11"    => 11,
        "R12"    => 12,
        "R13"    => 13,
        "R14"    => 14,
        "R15"    => 15,
        "SCREEN" => 16384,
        "KBD"    => 24576,
      }
      @location = 16
    end

    def add_location_symbol(symbol,location)
      table[symbol] = location
    end

    def fetch(symbol)
      if table[symbol]
        table[symbol]
      else
        table[symbol] = @location
        @location += 1
        table[symbol]
      end
    end

    private
    attr_reader :table
  end
end
