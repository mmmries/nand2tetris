module VM
  module Instruction
    class PushPointer
      attr_reader :value

      def initialize(line)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// push pointer #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @#{this_that}
          D=M

          @SP
          A=M
          M=D
          D=A+1
          @SP
          M=D
        )
      end

      def this_that
        value == 0 ? "THIS" : "THAT"
      end
    end
  end
end
