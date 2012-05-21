class Communicator
  attr_reader :listeners
  @listeners={}
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

  def transmit(address, package)
    self.class.transmit(self, address, package)
  end

  def self.transmit(sender, address, package)
    listeners[address].receive sender, package
  end

  def receive(sender, package)
    listeners.each do |listener|
      listener.receive(sender, package)
    end
  end
end
