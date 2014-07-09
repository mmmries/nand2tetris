require 'spec_helper'

describe VM::Instruction::PushConstant do
  subject{ described_class.new("push constant 75") }

  it "builds assemblies" do
    expect(subject.to_assemblies).to eq(%w(@75 D=A @SP A=M M=D D=A+1 @SP M=D))
  end

  it "builds commented assemblies" do
    expect(subject.commented_assemblies.first).to eq("// push constant 75")
  end
end
