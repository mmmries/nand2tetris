module VM
  module Instruction
    class PushConstant
      attr_reader :value

      def initialize(line)
        @value = line[14..-1].to_i
      end

      def to_assemblies
        nil
      end
    end
  end
end
