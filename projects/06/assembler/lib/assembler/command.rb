module Assembler
  class Command
    def self.build(str)
      if str.start_with?('@')
        Address.new(str)
      else
        Computation.new(str)
      end
    end
  end
end

require 'assembler/address'
require 'assembler/computation'
