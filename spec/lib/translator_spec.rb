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
    context "when receives greetings" do
      it "updates bros table" do
        client_mock.should_receive(:update_bros).with(bros_mock)
        subject.receive sender_mock, {:message => 'ay bro', :bros => bros_mock}.to_json
      end
    end

    context "when receives regular message" do
      it "passes message to client" do
        client_mock.should_receive(:message).with("random stuff")
        subject.receive sender_mock, { :message => 'random stuff' }.to_json
      end
    end

    context "when recives broken json" do
      it "doesn't raise an exception" do
        lambda {
          subject.receive sender_mock, 'blah blah'
        }.should_not raise_error(JSON::ParserError)
      end

      it "returns nil" do
        subject.receive(sender_mock, 'blah blah').should be_nil
      end
    end
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
