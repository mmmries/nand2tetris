module VM
  module Instruction
    class PopStatic
      attr_reader :value, :context

      def initialize(line, context)
        @value = line.split.last.to_i
        @context = context
      end

      def commented_assemblies
        ["// pop static #{value}"] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          M=M-1
          A=M
          D=M

          @#{asm_label}
          M=D
        )
      end

      def asm_label
        "#{context.basename}$#{value}"
      end
    end
  end
end
