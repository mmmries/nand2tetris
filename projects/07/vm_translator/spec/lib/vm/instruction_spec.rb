require 'spec_helper'

describe VM::Instruction do
  def inst(line)
    VM::Instruction.build_for(line)
  end

  it "handles comment lines" do
    inst = inst("// ohai guyz")
    expect(inst).to be_a(VM::Instruction::NoOp)
  end

  it "handles push constant commands" do
    inst = inst("push constant 7")
    expect(inst).to be_a(VM::Instruction::PushConstant)
    expect(inst.value).to eq(7)
  end

  it "handles add commands" do
    inst = inst("add")
    expect(inst).to be_a(VM::Instruction::Add)
  end
end
