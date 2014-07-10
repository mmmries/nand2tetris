module VM
  module Instruction
    class PushThis
      attr_reader :value

      def initialize(line, context)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// push this #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @#{value}
          D=A
          @THIS
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
