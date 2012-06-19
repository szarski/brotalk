require 'spec_helper'

describe Bro do
  describe "#initialize" do
    let_mocks :address, :supernode

    it "should take address and supernode" do
      bro = Bro.new address, supernode
      bro.address.should == address
      bro.supernode?.should == supernode
    end
  end
end
