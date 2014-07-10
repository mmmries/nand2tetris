module VM
  module Instruction
    class PushConstant
      attr_reader :value

      def initialize(line, context)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// push constant #{value}"] + to_assemblies
      end

      def to_assemblies
        [
          "@#{value}",
          "D=A",
          "@SP",
          "A=M",
          "M=D",
          "D=A+1",
          "@SP",
          "M=D"
        ]
      end
    end
  end
end
