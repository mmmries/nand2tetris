require 'spec_helper'
require_relative '../../lib/assembler.rb'

describe Assembler do
  subject { Assembler }

  context "a program with no symbols" do
    Given(:assembly){ fixture("Add.asm") }
    Given(:binary){ fixture("Add.hack") }
    Then{ subject.assemble(assembly).should eq(binary) }
  end

  context "a simple program with symbols" do
    Given(:assembly){ fixture("Max.asm") }
    Given(:binary){ fixture("Max.hack") }
    Then{ subject.assemble(assembly).should eq(binary) }
  end

  context "a basic gui program" do
    Given(:assembly){ fixture("Rect.asm") }
    Given(:binary){ fixture("Rect.hack") }
    Then{ subject.assemble(assembly).should eq(binary) }
  end

  context "a game" do
    Given(:assembly){ fixture("Pong.asm") }
    Given(:binary){ fixture("Pong.hack") }
    Then{ subject.assemble(assembly).should eq(binary) }
  end
end
