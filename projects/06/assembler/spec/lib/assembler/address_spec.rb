require 'spec_helper'
require 'assembler/command'

describe Assembler::Address do
  Given(:str){ "@1" }
  Given(:address){ Assembler::Address.new(str) }
  Then{ address.location.should == 1 }
  Then{ address.binary.should == "0000000000000001" }
end
