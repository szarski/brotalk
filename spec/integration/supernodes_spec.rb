require 'spec_helper'

describe "supernodes" do

  before {Communicator.clear_listeners}

  def c
    r=Client.new; r.start_listening; r
  end

  def addresses
    Communicator.listeners.keys
  end

  it "nodes convey an election" do
    c1, c2, c3 = c, c, c
    c1.greet addresses[1]
    c3.greet addresses.first

    c3.bros_table.count.should == 3

    c1.should_not be_supernode
    c2.should be_supernode
    c3.should_not be_supernode
  end
end
