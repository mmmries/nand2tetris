require 'vm/instruction/no_op'

module VM
  module Instruction
    def self.build_for(line)
      NoOp.new(line)
    end
  end
end
