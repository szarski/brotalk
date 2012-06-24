require "socket"
require "lib/communicator/udp_listener"
require "lib/communicator/udp_sender"

module Communicator
  BROTALK_PORT=8899

  class UDP
    attr_reader :listeners, :udp_listener, :udp_sender

    def initialize
    end

    def register_listener(listener)
      @listeners << listener
    end

    def start_listening
      Thread.new do
        udp_listener = UDPListener.new(address, port, self)
        udp_listener.listen
      end
    end

    def transmit(package, address, port=BROTALK_PORT)
      UDPSender.send_message(package, address, port)
    end

    def receive(sender, package)
      listeners.each do |listener|
        listener.receive(sender, package)
      end
    end
  end

  class Virtual
    attr_reader :listeners
    def self.clear_listeners
      @listeners={}
      @loggers = []
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
      log "#{sender_address} -> #{address} : #{package}"
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

    def self.register_logger(logger)
      @loggers << logger
    end

    def self.log(message)
      loggers.each do |logger|
        logger.log message
      end
    end

    def self.loggers
      @loggers
    end
  end

  DEFAULT_CLASS = Virtual

end
