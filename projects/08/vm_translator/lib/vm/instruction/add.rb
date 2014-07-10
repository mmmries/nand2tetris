module VM
  module Instruction
    class Add
      def initialize(line, context)

      end

      def commented_assemblies
        ['// add'] + to_assemblies
      end

      def to_assemblies
        %w(@SP D=M-1 M=D A=M D=M @R13 M=D @SP D=M-1 M=D A=M D=M @R14 M=D @R13 D=M @R14 D=D+M @SP A=M M=D D=A+1 @SP M=D)
      end
    end
  end
end
