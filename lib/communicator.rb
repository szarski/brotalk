module Communicator
  class UDP
    attr_reader :listeners

    def initialize
      @listeners = []
    end

    def register_listener(listener)
      @listeners << listener
    end

    def start_listening
      #TODO:
      #
      # start a new thread,
      # check updates periodically
      # call #receive if something comes
    end

    def transmit(address, package)
      #TODO:
      #
      # send data to socket
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
