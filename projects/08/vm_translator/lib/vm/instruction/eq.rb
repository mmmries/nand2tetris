require 'securerandom'
module VM
  module Instruction
    class Eq
      attr_reader :id

      def initialize(line, context)
        @id = SecureRandom.hex(4)
      end

      def commented_assemblies
        ['// eq'] + to_assemblies
      end

      def to_assemblies
        %W(
          @SP
          D=M-1
          M=D
          A=M
          D=M
          @R13
          M=D

          @SP
          D=M-1
          M=D
          A=M
          D=M
          @R14
          M=D

          @R13
          D=M
          @R14
          D=D-M
          @#{id}.NOT_EQUAL
          D;JNE

          D=-1
          @#{id}.PUSH_RESULT
          1;JMP

          (#{id}.NOT_EQUAL)
          D=0

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
