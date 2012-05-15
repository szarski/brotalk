require "spec_helper"
require 'json'

describe Translator::Receiver do
  let(:client) {mock}
    describe "#initialize" do
    it "should initialize a new instance" do
      described_class.new(client).client.should == client
    end
  end

  subject {Translator::Receiver.new(client)}
  let(:sender) {mock}
  let(:bros) {[1,2,3]}

  describe "#receive" do

    it "should understand greetings" do
      client.should_receive(:update_bros).with(bros)
      subject.receive sender, {:message => 'ay bro', :bros => bros}.to_json
    end

    it "should react to gibberish" do
      client.should_not_receive(:register_peer)
      subject.receive sender, {message: 'whay yuuuuu no tell me dat im preeetty'}.to_json
    end
    
    it "should not raise on broken json"
  end
end
