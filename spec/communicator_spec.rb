require "spec_helper"

describe "Communicator" do
  describe "#initialize" do
  end

  describe "#start_listening" do
    it "should take port as argument and start listening to incomming connections"
  end

  describe "#register_listener" do
    it "should take any object as an argument and add it to the #listeners array"
  end

  describe "#listeners" do
    it "should be an array"
    it "is empty by default"
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
