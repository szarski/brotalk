require "spec_helper"

describe Parser do
  let(:parent) {mock}
  it "should initialize a new instance" do
    Parser.new(parent).parent.should == parent
  end

  subject {Parser.new(parent)}
end
