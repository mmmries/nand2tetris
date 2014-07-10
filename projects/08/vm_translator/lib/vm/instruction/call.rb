module VM
  module Instruction
    class Call
      attr_reader :function, :arguments
      def initialize(line, context)
        words = line.split
        words.shift
        @function = words.shift
        @arguments = words.map(&:to_i)
      end

      def commented_assemblies
        ["// call #{function} #{arguments.join}"] + to_assemblies
      end

      def to_assemblies
        []
      end
    end
  end
end
