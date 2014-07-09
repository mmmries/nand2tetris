module VM
  module Instruction
    class PopStatic
      attr_reader :value

      def initialize(line)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// pop static #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          M=M-1
          A=M
          D=M
          
          @#{value + 16}
          M=D
        )
      end
    end
  end
end
