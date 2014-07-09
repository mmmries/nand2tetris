require 'securerandom'
module VM
  module Instruction
    class IfGoto
      attr_reader :label_name

      def initialize(line)
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

          @#{label_name}
          D;JNE
        )
      end
    end
  end
end
