require 'securerandom'
module VM
  module Instruction
    class Lt
      attr_reader :id

      def initialize(line)
        @id = SecureRandom.hex(4)
      end

      def commented_assemblies
        ['// lt'] + to_assemblies
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
          @#{id}.LESS_THAN
          D;JLT

          D=0
          @#{id}.PUSH_RESULT
          1;JMP

          (#{id}.LESS_THAN)
          D=-1

          (#{id}.PUSH_RESULT)
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
