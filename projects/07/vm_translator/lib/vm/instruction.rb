require 'vm/instruction/no_op'
require 'vm/instruction/push_constant'

module VM
  module Instruction
    def self.build_for(line)
      line = strip_comment(line)
      if line.empty?
        NoOp.new(line)
      else
        PushConstant.new(line)
      end
    end

    def self.strip_comment(line)
      if idx = line.index("//")
        line = line.slice(0,idx)
      end
      line
    end
  end
end
