require 'spec_helper'

def scenario(*args, &block)
  it(*args, &block)
end

describe "communication" do
  let(:ip1) {mock}
  let(:package) {mock}

  let(:communicator_1) {Communicator.new}
  let(:communicator_2) {Communicator.new}

  before {communicator_1.start_listening;ip1}
  #because he signed up as the last one:
  let(:ip1) {Communicator.listeners.keys.last}

  scenario "two communicators talk to each other" do
    communicator_1.should_receive(:receive).with(communicator_2, package)
    communicator_2.transmit(ip1, package)
  end
end
