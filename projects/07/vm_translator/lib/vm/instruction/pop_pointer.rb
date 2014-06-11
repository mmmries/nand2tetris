module VM
  module Instruction
    class PopPointer
      attr_reader :value

      def initialize(line)
        @value = line.split.last.to_i
      end

      def commented_assemblies
        ["// pop pointer #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          M=M-1
          A=M
          D=M
          
          @#{this_that}
          M=D
        )
      end

      def this_that
        value == 0 ? "THIS" : "THAT"
      end
    end
  end
end
