module VM
  module Instruction
    class PushLocal
      attr_reader :value

      def initialize(line)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// push local #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @#{value}
          D=A
          @LCL
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
