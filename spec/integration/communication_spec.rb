require 'spec_helper'

def scenario(*args, &block)
  it(*args, &block)
end

describe "communication" do
  let(:ip1) {mock}
  let(:package) {mock}

  scenario "two communicators talk to each other" do
    c1 = Communicator.new
    c2 = Communicator.new

    c1.should_receive(:receive).with(c2, package)

    c1.start_listening(ip1)
    c2.transmit(ip1, package)
  end
end
