require 'securerandom'
module VM
  module Instruction
    class IfGoto
      attr_reader :label_name, :context

      def initialize(line, context)
        @context = context
        @label_name = line.split[1..-1].join
      end

      def commented_assemblies
        ['// if-goto ' << label_name] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          D=M-1
          M=D
          A=M
          D=M

          @#{fully_qualified_name}
          D;JNE
        )
      end

      def fully_qualified_name
        "#{context.function}$#{label_name}"
      end
    end
  end
end
