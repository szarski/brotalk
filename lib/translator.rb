require File.join(File.dirname(__FILE__), './translator/message_parser')
require File.join(File.dirname(__FILE__), './translator/message_builder')

module Translator
  class Receiver
    include MessageParser

    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def receive(sender, raw_package)
      package = parse_message(raw_package)
      route_message(package, sender)
    end

    private
      def route_message(parsed_message, sender)
        case parsed_message[:message_type]
        when :greetings
          @client.update_bros [sender]
          @client.update_bros parsed_message["bros_table"]
        when :regular
          @client.message parsed_message["message"]
        end
      end
    #EOF private
  end

  class Sender
    include MessageBuilder

    attr_accessor :communicator

    def initialize(communicator)
      @communicator = communicator
    end

    def greet(sender, bros_table)
      greet_json = build_message(:greeting, bros_table)
      @communicator.transmit(sender, greet_json)
    end

    def send_message(sender, message)
      message_json = build_message(:regular, message)
      @communicator.transmit(sender, message_json)
    end
  end
end
