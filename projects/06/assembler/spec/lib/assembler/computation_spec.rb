require 'spec_helper'
require 'assembler/command'

describe Assembler::Computation do
  Given(:computation){ Assembler::Computation.new(str) }

  context "parse M=D;JNE" do
    Given(:str){ "M=D;JNE" }
    Then{ computation.operation.should == "D" }
    Then{ computation.destination.should == "M" }
    Then{ computation.jump.should == "JNE" }
  end

  context "parse AM=D+1;JGT" do
    Given(:str){ "AM=D+1;JGT" }
    Then{ computation.operation.should == "D+1" }
    Then{ computation.destination.should == "AM" }
    Then{ computation.jump.should == "JGT" }
  end

  context "parse 1;JLT" do
    Given(:str){ "1;JLT" }
    Then{ computation.operation.should == "1" }
    Then{ computation.destination.should == "" }
    Then{ computation.jump.should == "JLT" }
  end

  context "parse M=D" do
    Given(:str){ "M=D" }
    Then{ computation.operation.should == "D" }
    Then{ computation.destination.should == "M" }
    Then{ computation.jump.should be_nil }
  end

  context "#binary" do
    {
      "0"   => "1110101010000000",
      "1"   => "1110111111000000",
      "-1"  => "1110111010000000",
      "D&A" => "1110000000000000",
      "D=A"   => "1110110000010000",
      "D=D+A" => "1110000010010000",
      "M=D"   => "1110001100001000",
      "D;JGE" => "1110001100000011",
    }.each do |command, binary|
      context "#{command}" do
        let(:str){ command }
        it "creates a binary of #{binary}" do
          computation.binary.should eq(binary)
        end
      end
    end
  end
end
