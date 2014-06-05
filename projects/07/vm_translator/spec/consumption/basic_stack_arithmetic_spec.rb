require 'spec_helper'

describe "Simple Stack Arithmetic" do
  let(:input){ fixture_contents("simple_add.vm") }
  let(:output){ fixture_contents("simple_add.asm") }

  it "translates vm instructions into assembly bytecode" do
    expect(VmTranslator.translate(input)).to eq(output)
  end
end
