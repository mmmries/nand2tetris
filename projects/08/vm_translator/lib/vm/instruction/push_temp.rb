module VM
  module Instruction
    class PushTemp
      attr_reader :value

      def initialize(line)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// push temp #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @R#{value + 5}
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
