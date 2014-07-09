module VM
  module Instruction
    class PushThat
      attr_reader :value

      def initialize(line)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// push that #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @#{value}
          D=A
          @THAT
          A=D+M
          D=M

          @SP
          A=M
          M=D
          D=A+1
          @SP
          M=D
        )
      end
    end
  end
end
