require 'spec_helper'

def scenario(*args, &block)
  it(*args, &block)
end

describe "communication" do
  let(:ip1) {mock}
  let(:package) {mock}

  let(:communicator_1) {Communicator::DEFAULT_CLASS.new}
  let(:communicator_2) {Communicator::DEFAULT_CLASS.new}

  before {communicator_1.start_listening;ip1}
  #because he signed up as the last one:
  let(:ip1) {Communicator::DEFAULT_CLASS.listeners.keys[Communicator::DEFAULT_CLASS.listeners.keys.count - 2]}
  let(:ip2) {Communicator::DEFAULT_CLASS.listeners.keys.last}

  scenario "two communicators talk to each other" do
    communicator_1.start_listening
    communicator_2.start_listening
    communicator_1.should_receive(:receive).with(ip2, package)
    communicator_2.transmit(ip1, package)
  end
end
