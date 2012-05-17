require File.join(File.dirname(__FILE__), '../spec_helper')

describe Translator::Receiver do
  let(:client_mock) { double("client").as_null_object }
  let(:sender_mock) { double("sender").as_null_object }
  let(:bros_mock) { [1,2,3] }
  subject { Translator::Receiver.new(client_mock) }

  describe "#initialize" do
    it "sets @client" do
      subject.client.should eq(client_mock)
    end
  end

  describe "#receive" do
    context "receives greetings" do
      it "updates bros table" do
        client_mock.should_receive(:update_bros).with(bros_mock)
        subject.receive sender_mock, {:message => 'ay bro', :bros => bros_mock}.to_json
      end
    end

    context "receives message" do
      it "passes message to client" do
        pending
        client_mock.should_receive(:get_message)
        subject.receive sender_mock, {message: 'random stuff'}.to_json
      end
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
