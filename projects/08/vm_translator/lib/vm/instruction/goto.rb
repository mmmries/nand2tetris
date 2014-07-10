require 'securerandom'
module VM
  module Instruction
    class Goto
      attr_reader :label_name, :context

      def initialize(line, context)
        @context = context
        @label_name = line.split[1..-1].join
      end

      def commented_assemblies
        ['// goto ' << label_name] + to_assemblies
      end

      def to_assemblies
        %W(
          @#{fully_qualified_name}
          1;JMP
        )
      end

      def fully_qualified_name
        "#{context.function}$#{label_name}"
      end
    end
  end
end
