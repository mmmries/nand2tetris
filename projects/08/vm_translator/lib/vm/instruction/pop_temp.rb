module VM
  module Instruction
    class PopTemp
      attr_reader :value

      def initialize(line, context)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// pop temp #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          M=M-1
          A=M
          D=M

          @R#{value + 5}
          M=D
        )
      end
    end
  end
end
