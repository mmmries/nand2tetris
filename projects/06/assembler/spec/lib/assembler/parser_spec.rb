require 'spec_helper'
require 'assembler/parser'

describe Assembler::Parser do
  context "commands" do
    Given(:assembly){ fixture("Add.asm") }
    Given(:parser){ Assembler::Parser.new(assembly) }
    Then{ parser.commands.size.should eq(6) }
    Then do
      parser.commands.each do |command|
        command.should be_a(Assembler::Command)
      end
    end
    Then{ parser.commands[0].should be_a(Assembler::Address) }
    Then{ parser.commands[1].should be_a(Assembler::Computation) }
    Then{ parser.commands[2].should be_a(Assembler::Address) }
    Then{ parser.commands[3].should be_a(Assembler::Computation) }
    Then{ parser.commands[4].should be_a(Assembler::Address) }
    Then{ parser.commands[5].should be_a(Assembler::Computation) }
  end
end
