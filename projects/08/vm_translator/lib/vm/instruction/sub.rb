module VM
  module Instruction
    class Sub
      def initialize(line)
      end

      def commented_assemblies
        ['// sub'] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          D=M-1
          M=D
          A=M
          D=M
          @R14
          M=D

          @SP
          D=M-1
          M=D
          A=M
          D=M
          @R13
          M=D

          @R13
          D=M
          @R14
          D=D-M

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
