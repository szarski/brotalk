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

  describe "#parse_bros" do
    let(:bros) {mock}
    let(:bros_json) {mock}

    it "should create Bro instances out of a json string" do
      Bro.stub(:from_json).with(bros_json).and_return bros
      subject.parse_bros(bros_json).should == bros
    end
  end

  describe "#receive" do
    context "when receives greetings" do
      before {subject.stub(:parse_bros).with(bros_mock).and_return(parsed_bros)}
      before {subject.stub(:parse_bros).with([sender_mock]).and_return(parsed_sender)}
      let_mocks :parsed_bros, :parsed_sender, :all_bros

      it "updates bros table with the result of #parse_bros" do
        parsed_bros.stub(:+).with {|bro| bro.first.address == sender_mock}.and_return(all_bros)
        client_mock.should_receive(:update_bros).with(all_bros, sender_mock)
        client_mock.stub(:greet_bro)
        subject.receive sender_mock, {:message => 'ay bro', :bros_table => bros_mock}.to_json
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
  let(:sender_mock) { double("sender").as_null_object }
  let(:communicator_mock) { double("communicator").as_null_object }
  let(:supernode_mock) { double("supernode").as_null_object }

  subject { Translator::Sender.new(communicator_mock) }

  describe "#initialize" do
    it "sets @communicator" do
      subject.communicator.should eq(communicator_mock)
    end
  end

  describe "#greet" do
    let(:bros_table_mock) { double("bros_table").as_null_object }
    let(:built_json) { "{\"bros_table\":\"[1,2,3]\"}" }

    before(:each) do
      subject.stub(:build_message).and_return(built_json)
    end

    it "invokes #build_message with message_type :greeting and bros_table" do
      subject.should_receive(:build_message).with(:greeting, {
        :bros_table => bros_table_mock,
        :supernode => supernode_mock
      })
      subject.greet(sender_mock, bros_table_mock, supernode_mock)
    end

    it "invokes Communicator#transmit with address and proper json" do
      communicator_mock.should_receive(:transmit).with(built_json, sender_mock)
      subject.greet(sender_mock, bros_table_mock, supernode_mock)
    end
  end

  describe "#send_message" do
    let(:message) { "hello" }
    let(:built_json) { "{\"message\":\"hello\"}" }

    before(:each) do
      subject.stub(:build_message).and_return(built_json)
    end

    it "invokes #build_message with message_type :regular and message" do
      subject.should_receive(:build_message).with(:regular, message)
      subject.send_message(sender_mock, message)
    end

    it "invokes Communicator#transmit with address and proper json" do
      communicator_mock.should_receive(:transmit).with(built_json, sender_mock)
      subject.send_message(sender_mock, message)
    end
  end

  describe "#ping" do
    let(:built_json) { "{\"message\":\"ping\"}" }

    before(:each) do
      subject.stub(:build_message).and_return(built_json)
    end

    it "invokes #build_message with message_type :ping and message" do
      subject.should_receive(:build_message).with(:ping)
      subject.ping(sender_mock)
    end

    it "invokes Communicator#transmit with address and proper json" do
      communicator_mock.should_receive(:transmit).with(built_json, sender_mock)
      subject.ping(sender_mock)
    end
  end

  describe "#pong" do
    let(:built_json) { "{\"message\":\"ping\"}" }

    before(:each) do
      subject.stub(:build_message).and_return(built_json)
    end

    it "invokes #build_message with message_type :pong and message" do
      subject.should_receive(:build_message).with(:pong)
      subject.pong(sender_mock)
    end

    it "invokes Communicator#transmit with address and proper json" do
      communicator_mock.should_receive(:transmit).with(built_json, sender_mock)
      subject.pong(sender_mock)
    end
  end
end
