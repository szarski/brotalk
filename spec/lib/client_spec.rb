require File.join(File.dirname(__FILE__), '../spec_helper')


describe Client do

  describe "#initialize" do
    let(:communicator) {mock}
    let(:translator_receiver) {mock}
    let(:translator_sender) {mock}

    it "initializes the communicator" do
      Communicator.stub(:new).with.and_return communicator
      communicator.stub(:register_listener)
      described_class.new.communicator.should == communicator
    end

    it "initializes the translator receiver with itself as a parent" do
      Translator::Receiver.stub(:new).with{|client| client.is_a?(Client)}.and_return translator_receiver
      described_class.new.translator_receiver.should == translator_receiver
    end

    it "tells communicator to register translator receiver as a listener" do
      Communicator.stub(:new).and_return communicator
      Translator::Receiver.stub(:new).and_return translator_receiver
      communicator.should_receive(:register_listener).with(translator_receiver)
      described_class.new
    end

    it "initializes the translator sender, gives it the communicator on initialization and stores a handler" do
      Translator::Sender.stub(:new).with(communicator).and_return translator_sender
      Client.any_instance.stub(:communicator).and_return communicator
      described_class.new.translator_sender.should == translator_sender
    end

    it "initializes the twitter_wrapper" do
      pending "we don't need this yet"
    end
  end

  describe "#start_with_twitter" do
    it "invokes TwitterWrapper#scan_addresses and issues translator.greet() with each of them and passes #bro_table"
  end

  describe "#start" do
    let(:communicator) {mock}
    before {subject.stub(:communicator).and_return(communicator)}

    it "should call Communicator#start_listening" do
      communicator.should_receive(:start_listening)
      subject.start_listening
    end
  end

  describe "#bro_table" do
    it "should be empty on initialize"
  end

  describe "#update_bros" do
    it "should update the bro table with new records and issue translator.greet with each of them and the #bro_table"
  end
end
