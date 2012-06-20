require 'spec_helper'

describe Bro do
  describe "#initialize" do
    let_mocks :address, :supernode
    subject {Bro.new(address, supernode)}

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

      [bro_a1, bro_b].should == [bro_a1, bro_b]
      [bro_a1, bro_b].should_not == [bro_a1, bro_a1]
    end
  end

  describe "<=>" do
    it "should allow sorting" do
      lambda {[Bro.new('aaa',false), Bro.new('bbb',true)].sort}.should_not raise_error
    end
  end

  describe "#to_json" do
    it "transforms properly" do
      Bro.new('abc', false).to_json.should == "\"abc%0\""
      Bro.new('abc', true).to_json.should == "\"abc%1\""
    end
  end

  describe ".from_json" do
    let(:bros_json) {%w{aaa%0 bbb%1 ccc%0}}
    let(:bros) {[Bro.new('aaa',false),Bro.new('bbb',true),Bro.new('ccc',false)]}

    it "should load from an array" do
      #bros_json.each_with_index {|bro, index| Bro.stub(:new).with(bro).and_return(bros[index])}
      described_class.from_json(bros_json).should == bros
    end
  end
end
