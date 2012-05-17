class Communicator
  def self.listeners
    @listeners||={}
  end

  def self.register(ip, communicator)
    @listeners[ip] = communicator
  end
end
