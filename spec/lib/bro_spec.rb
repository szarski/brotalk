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

  describe "#eql? and related" do
    it "should compare the address only" do
      bro_a1 = Bro.new('a', false)
      bro_a2 = Bro.new('a', true)
      bro_b = Bro.new('b', false)

      bro_a1.should == bro_a2
      bro_a1.should_not == bro_b

      [bro_a1, bro_a2, bro_b].uniq.should == [bro_a1, bro_b]
    end
  end
end
