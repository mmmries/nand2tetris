require 'securerandom'
module VM
  module Instruction
    class Call
      attr_reader :function, :arity, :return_label, :context
      def initialize(line, context)
        _, @function, arity = line.split
        @arity = arity.to_i
        @return_label = SecureRandom.hex(4)
        @context = context
      end

      def commented_assemblies
        ["// call #{function} #{arity}"] + to_assemblies
      end

      def to_assemblies
        push_return_address +
          push_local +
          push_arg +
          push_this +
          push_that +
          reset_arg +
          set_local +
          goto_f +
          return_label_assembly
      end

      def push_return_address
        %W(//push_return @#{return_label} D=A @SP A=M M=D D=A+1 @SP M=D)
      end

      def push_local
        %W(//push_local @LCL D=M @SP A=M M=D D=A+1 @SP M=D)
      end

      def push_arg
        %W(//push_arg @ARG D=M @SP A=M M=D D=A+1 @SP M=D)
      end

      def push_this
        %W(//push_this @THIS D=M @SP A=M M=D D=A+1 @SP M=D)
      end

      def push_that
        %W(//push_that @THAT D=M @SP A=M M=D D=A+1 @SP M=D)
      end

      def reset_arg
        %W(//push_arg @SP D=M @#{arity + 5} D=D-A @ARG M=D)
      end

      def set_local
        %w(//set_local @SP D=M @LCL M=D)
      end

      def goto_f
        %W(@#{function} 1;JMP)
      end

      def return_label_assembly
        %W( (#{return_label}) )
      end
    end
  end
end
