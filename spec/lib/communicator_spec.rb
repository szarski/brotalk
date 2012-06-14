require File.join(File.dirname(__FILE__), '../spec_helper')

describe Communicator do

  subject {Communicator.new}
  let(:package) {mock}
  let(:receiver_ip) {mock}
  let(:sender) {mock}
  let(:sender_address) {mock}
  before {Communicator.stub(:reverse_lookup).with(sender).and_return(sender_address)}

  describe ".listeners" do
    it "should be empty by default" do
      pending "This will raise because other examples set its contents already"
      described_class.listeners.should == {}
    end
  end

  describe ".register" do
    it "should add the communicator" do
      described_class.register(subject)
      described_class.listeners.values.last.should == subject
      described_class.listeners.keys.last.should be_a(String)
    end
  end

  describe "#initialize" do
  end

  describe "#start_listening" do
    it "should start listening to incomming connections" do
      described_class.should_receive(:register).with(subject)
      subject.start_listening
    end
  end

  describe "#register_listener" do
    let(:listener) {mock}
    it "should take any object as an argument and add it to the #listeners array" do
      subject.register_listener(listener)
      subject.listeners.should include(listener)
    end
  end

  describe "#listeners" do
    it "should be an array" do
      subject.listeners.should be_a(Array)
    end

    it "is empty by default" do
      subject.listeners.should be_empty
    end
  end

  describe "#transmit" do
    it "should accept sender, receiver_address and package, perform sender reverse lookup and send them away" do
      described_class.should_receive(:transmit).with(subject, receiver_ip, package)
      subject.transmit(receiver_ip, package)
    end
  end

  describe ".transmit" do
    it "should invoke #receive on the receiver communicator" do
      ip = mock
      subject.should_receive(:receive).with sender_address, package
      described_class.listeners.stub(:[]).with(ip).and_return(subject)
      described_class.transmit(sender, ip, package)
    end
  end

  describe "#receive" do
    let(:sender) {mock}
    let(:package) {mock}

    it "should accept sender and package" do
      lambda {subject.receive mock, mock}.should_not raise_error
    end

    context "there are listeners assigned" do
      let(:listeners) {[mock, mock, mock]}
      before {subject.stub(:listeners).and_return(listeners)}

      it "should call #receive on each of the #listeners" do
        listeners.each {|listener| listener.should_receive(:receive).with(sender, package)}
        subject.receive sender, package
      end
    end
  end
end
