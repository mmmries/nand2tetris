module VM
  module Instruction
    class PushStatic
      attr_reader :value, :context

      def initialize(line, context)
        @value = line.split.last.to_i
        @context = context
      end

      def commented_assemblies
        ["// push static #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @#{asm_label}
          D=M

          @SP
          A=M
          M=D
          D=A+1
          @SP
          M=D
        )
      end

      def asm_label
        "#{context.basename}$#{value}"
      end
    end
  end
end
