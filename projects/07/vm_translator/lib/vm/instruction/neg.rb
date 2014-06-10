module VM
  module Instruction
    class Neg
      def initialize(line)
      end

      def commented_assemblies
        ['// neg'] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          D=M-1
          M=D
          A=M
          D=-M

          @SP
          A=M
          M=D
          D=A+1
          @SP
          M=D)
      end
    end
  end
end
