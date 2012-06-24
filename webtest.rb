require File.join(File.dirname(__FILE__), 'lib', 'brotalk')
require 'drb'

class Simulator
  attr_reader :logs

  def initialize
    @logs = []
    Communicator::DEFAULT_CLASS.register_logger(self)
    20.times do
      c = Client.new
      c.start_listening
      sleep rand * 1
    end
  end

  def log(msg)
    @logs << msg
  end

  def listeners
    Communicator::DEFAULT_CLASS.listeners
  end

  def greet(sender, recipient)
    listeners[sender].listeners.first.client.greet recipient
  end

  def messages
  end
end

simulator = Simulator.new

DRb.start_service('druby://localhost:9000', simulator)
DRb.thread.join
