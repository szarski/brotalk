require File.join(File.dirname(__FILE__), 'lib', 'brotalk')
require 'drb'

class Simulator
  attr_reader :logs

  def initialize
    Client.instance_variable_set("@zombie_check_limit", 30)
    Client.instance_variable_set("@zombie_kill_limit", 60)
    @logs = []
    Communicator::Virtual.register_logger(self)
    20.times do
      c = Client.new(false)
      c.start_listening
      sleep((rand * 6).round)
    end
  end

  def log(msg)
    @logs << msg
  end

  def listeners
    Communicator::Virtual.listeners
  end

  def greet(sender, recipient)
    listeners[sender].listeners.first.client.greet recipient
  end

  def remove(address)
    Communicator::Virtual.listeners.delete address
  end

  def messages
  end
end

simulator = Simulator.new

DRb.start_service('druby://localhost:9000', simulator)
DRb.thread.join
