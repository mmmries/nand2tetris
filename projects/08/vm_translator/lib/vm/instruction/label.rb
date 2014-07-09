module VM
  module Instruction
    class Label
      attr_reader :label_name
      def initialize(line)
        @label_name = line.split[1..-1].join
      end

      def commented_assemblies
        ['// label ' << label_name] + to_assemblies
      end

      def to_assemblies
        %W(
          (#{label_name})
        )
      end
    end
  end
end
