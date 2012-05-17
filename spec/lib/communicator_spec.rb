require File.join(File.dirname(__FILE__), '../spec_helper')

describe Communicator do

  subject {Communicator.new}
  let(:ip) {mock}

  describe ".listeners" do
    it "should be empty by default" do
      described_class.listeners.should == {}
    end
  end

  describe ".register" do
    it "should add the communicator" do
      described_class.register(ip, subject)
      described_class.listeners[ip].should == subject
    end
  end

  describe "#initialize" do
  end

  describe "#start_listening" do
    it "should take port as argument and start listening to incomming connections" do
      described_class.should_receive(:register).with(ip, subject)
      subject.start_listening(ip)
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
    it "should accept receiver and package and send them away"
  end

  describe "#receive" do
    it "should accept sender and package"
    it "should call #receive on each of the #listeners"
  end

  describe "receiving packages" do
    it "should call self.receive with sender and package"
  end
end
