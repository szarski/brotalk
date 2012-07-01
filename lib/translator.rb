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

    def parse_bros(bros)
      Bro.from_json bros
    end

    private
      def route_message(parsed_message, sender)
        case parsed_message[:message_type]
        when :greetings
          bros_table = parse_bros(parsed_message["bros_table"]) +
            [Bro.new(sender, (parsed_message["supernode"].to_i > 0))]
          @client.update_bros(bros_table, sender)
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

    def greet(sender, bros_table, supernode)
      greet_json = build_message(:greeting, {:bros_table => bros_table, :supernode => supernode})
      @communicator.transmit(greet_json, sender)
    end

    def send_message(sender, message)
      message_json = build_message(:regular, message)
      @communicator.transmit(sender, message_json)
    end
  end
end
