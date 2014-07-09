require 'spec_helper'

describe VM::Instruction::Add do
  subject{ described_class.new("add") }

  it "builds assemblies" do
    expect(subject.to_assemblies).to eq(%w(@SP D=M-1 M=D A=M D=M @R13 M=D @SP D=M-1 M=D A=M D=M @R14 M=D @R13 D=M @R14 D=D+M @SP A=M M=D D=A+1 @SP M=D))
  end

  it "builds commented assemblies" do
    expect(subject.commented_assemblies.first).to eq("// add")
  end
end
