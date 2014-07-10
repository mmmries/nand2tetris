require 'vm/instruction/add'
require 'vm/instruction/and'
require 'vm/instruction/eq'
require 'vm/instruction/gt'
require 'vm/instruction/lt'
require 'vm/instruction/neg'
require 'vm/instruction/not'
require 'vm/instruction/no_op'
require 'vm/instruction/or'
require 'vm/instruction/sub'

require 'vm/instruction/push_argument'
require 'vm/instruction/push_constant'
require 'vm/instruction/push_local'
require 'vm/instruction/push_pointer'
require 'vm/instruction/push_static'
require 'vm/instruction/push_temp'
require 'vm/instruction/push_that'
require 'vm/instruction/push_this'

require 'vm/instruction/pop_argument'
require 'vm/instruction/pop_local'
require 'vm/instruction/pop_pointer'
require 'vm/instruction/pop_static'
require 'vm/instruction/pop_temp'
require 'vm/instruction/pop_that'
require 'vm/instruction/pop_this'

require 'vm/instruction/label'
require 'vm/instruction/goto'
require 'vm/instruction/if_goto'

require 'vm/instruction/function'
require 'vm/instruction/return'

module VM
  module Instruction
    def self.build_for(line)
      line = strip_comment(line)
      return NoOp.new if line.empty?

      one_word_klass = line.split[0].split('-').map{|w| w.capitalize}.join
      two_word_klass = line.split[0..1].map{|w| w.capitalize}.join
      if const_defined?("VM::Instruction::#{one_word_klass}")
        klass = const_get(one_word_klass)
      elsif const_defined?("VM::Instruction::#{two_word_klass}")
        klass = const_get(two_word_klass)
      else
        raise ArgumentError.new("Unrecognized command #{line}")
      end
      klass.new(line)
    end

    def self.strip_comment(line)
      if idx = line.index("//")
        line = line.slice(0,idx)
      end
      line
    end
  end
end
