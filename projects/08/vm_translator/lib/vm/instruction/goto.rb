require 'securerandom'
module VM
  module Instruction
    class Goto
      attr_reader :label_name

      def initialize(line)
        @label_name = line.split[1..-1].join
      end

      def commented_assemblies
        ['// goto ' << label_name] + to_assemblies
      end

      def to_assemblies
        %W(
          @#{label_name}
          1;JMP
        )
      end
    end
  end
end
