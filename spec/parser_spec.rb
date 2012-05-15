require "spec_helper"

describe Parser do
  let(:parent) {mock}
    describe "#initialize" do
    it "should initialize a new instance" do
      Parser.new(parent).parent.should == parent
    end
  end

  subject {Parser.new(parent)}
  let(:sender) {mock}

  describe "#react" do
    it "should understand greetings" do
      parent.should_receive(:register_peer).with(sender)
      response = subject.react sender, "ay bro"
      response.should == "ay"
    end

    it "should react to gibberish" do
      parent.should_not_receive(:register_peer)
      response = subject.react sender, "whay yuuuuu no tell me dat im preeetty"
      response.should == "u mad bro"
    end
  end
end
