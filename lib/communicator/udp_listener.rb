class UDPListener
  def initialize(communicator, address, port)
    @communicator = communicator
    @socket = UDPSocket.new
    @socket.bind(address, port)
  end

  def listen
    while !@socket.closed? do
      begin
        received_package = @socket.recvfrom(1000)
        sender_addr, sender_port = received_package[1][3], received_package[1][1]
        @communicator.receive(sender_addr, received_package[0])
      rescue => e
        puts e.to_s
        # log the error message?
        retry
      end
    end
  end
end
