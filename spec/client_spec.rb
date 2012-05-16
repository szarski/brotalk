require 'spec_helper'

describe Client do

  describe "#initialize" do
    it "initializes the communicator"
    it "initializes the translator receiver with itself as a parent"
    it "tells communicator to register translator receiver as a listener"
    it "initializes the translator sender, gives it the communicator on initialization and stores a handler"
    it "initializes the twitter_wrapper"
  end

  describe "#start_with_twitter" do
    it "invokes TwitterWrapper#scan_addresses and issues translator.greet() with each of them and passes #bro_table"
  end

  describe "#start" do
    it "should call Communicator#start_listening"
  end

  describe "#bro_table" do
    it "should be empty on initialize"
  end

  describe "#update_bros" do
    it "should update the bro table with new records and issue translator.greet with each of them and the #bro_table"
  end
end
