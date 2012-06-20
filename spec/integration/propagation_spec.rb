require 'spec_helper'

def scenario(*args, &block)
  it(*args, &block)
end

def list_bros_tables
  puts '* bros tables'
  clients.each do |client|
    puts '  ' + client.bros_table.inspect
  end
  puts '*'
end

describe "propagation" do
  let(:clients) {(1..10).to_a.collect {Client.new}}

  before {Communicator::DEFAULT_CLASS.clear_listeners}

  scenario "none of the bros is given any address, noone knows nobody" do
    clients.map &:start_listening
    clients.reject {|c| c.bros_table.empty?}.should be_empty
  end

  scenario "some of the bros are given the same bros address, only they know only each other" do
    clients.map &:start_listening
    clients[2].greet Communicator::DEFAULT_CLASS.listeners.keys.last
    clients[1].greet Communicator::DEFAULT_CLASS.listeners.keys.last
    clients[5].greet Communicator::DEFAULT_CLASS.listeners.keys.last

    bros_indexes = [1,2,5,9]
    other_bros_indexes = ((0..9).to_a - [1,2,5])
    clients.values_at(*bros_indexes).select {|c| c.bros_table.map(&:address).sort == Communicator::DEFAULT_CLASS.listeners.keys.values_at(*bros_indexes).sort}.count.should == 4
    clients.values_at(*other_bros_indexes).select {|c| c.bros_table.empty?}.count.should == 6
  end

  scenario "each bro is given the last bro's address, everyone knows everybody" do
    clients.map &:start_listening
    clients.map {|c| c.greet Communicator::DEFAULT_CLASS.listeners.keys.last}
    clients.select {|c| c.bros_table.map(&:address).sort == Communicator::DEFAULT_CLASS.listeners.keys.sort}.count.should == 10
  end
end
