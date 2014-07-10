module VM
  module Instruction
    class Return
      def initialize(line)
      end

      def commented_assemblies
        ["// return"] + to_assemblies
      end

      def to_assemblies
        frame_to_r13 +
          ret_addr_to_r14 +
          set_return_value +
          reset_stack_pointer +
          reset_that +
          reset_this +
          reset_arg +
          reset_local +
          goto_ret
      end

      private

      def frame_to_r13
        %w(@LCL D=M @R13 M=D)
      end

      def ret_addr_to_r14
        %w(@5 D=D-A @R14 M=D)
      end

      def set_return_value
        %w(@SP D=M-1 M=D A=M D=M @ARG A=M M=D)
      end

      def reset_stack_pointer
        %w(@ARG D=M+1 @SP M=D)
      end

      def reset_that
        %w(@R13 A=M-1 D=M @THAT M=D)
      end

      def reset_this
        %w(@R13 D=M @2 A=D-A D=M @THIS M=D)
      end

      def reset_arg
        %w(@R13 D=M @3 A=D-A D=M @ARG M=D)
      end

      def reset_local
        %w(@R13 D=M @4 A=D-A D=M @LCL M=D)
      end

      def goto_ret
        %w(@R14 A=M 1;JMP)
      end
    end
  end
end
