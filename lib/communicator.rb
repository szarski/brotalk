class Communicator
  attr_reader :listeners

  def self.clear_listeners
    @listeners={}
  end
  clear_listeners

  def self.listeners
    @listeners||={}
  end

  def self.register(communicator)
    ip = "ip_#{(10000*rand).round}"
    @listeners[ip] = communicator
  end

  def start_listening
    self.class.register self
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

  def self.reverse_lookup(bro)
    socket = self.listeners.to_a.select{|a,c| c == bro}.last
    if socket
      return socket.first
    else
      return nil
    end
  end

  def self.transmit(sender, address, package)
    sender_address = reverse_lookup(sender)
    #puts "#{sender_address} -> #{address} : #{package}"
    unless listeners[address]
      raise "address unregistered #{address.inspect}"
    end
    listeners[address].receive sender_address, package
  end

  def receive(sender, package)
    listeners.each do |listener|
      listener.receive(sender, package)
    end
  end
end
