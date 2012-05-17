class Communicator
  def self.listeners
    @listeners||={}
  end

  def self.register(ip, communicator)
    @listeners[ip] = communicator
  end

  def start_listening(ip)
    self.class.register ip, self
  end
end
