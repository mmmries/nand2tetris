require 'spec_helper'
require 'assembler/command'

describe Assembler::Address do
  Given(:address){ Assembler::Address.new(str) }

  context "constant" do
    Given(:str){ "@1" }    
    Then{ address.location.should == 1 }
    Then{ address.binary.should == "0000000000000001" }
  end

  context "symbol" do
    Given(:str){ "@HELLO" }
    Then{ address.symbol.should == "HELLO" }
    When{ address.resolve({"HELLO" => 7}) }
    Then{ address.location.should == 7 }
  end
end
