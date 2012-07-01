class UDPSender
  attr_accessor :socket

  def initialize(address, port)
    @socket = UDPSocket.new
    @socket.connect(address, port)
  end

  def send_message(message)
    @socket.send(message, 0)
  end

  def cleanup!
    @socket.close
  end

  def self.send_message(message, address, port)
    udp_sender = self.new(address, port)
    udp_sender.send_message(message)
    udp_sender.cleanup!
  end
end
