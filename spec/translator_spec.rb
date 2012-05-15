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

describe Translator::Sender do
  describe "#initialize" do
    it "should take communicator as argument and store"
  end

  describe "#greet" do
    it "should take sender and bros_table as argument and send appropriate json to the sender via communicator"
    #(JS) {message: "ay bro", bros: bros_table}
  end
end
