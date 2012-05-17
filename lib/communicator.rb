class Communicator
  attr_reader :listeners
  def self.listeners
    @listeners||={}
  end

  def self.register(ip, communicator)
    @listeners[ip] = communicator
  end

  def start_listening(ip)
    self.class.register ip, self
  end

  def initialize
    @listeners = []
  end

  def register_listener(listener)
    @listeners << listener
  end
end
