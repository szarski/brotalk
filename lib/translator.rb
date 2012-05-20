require File.join(File.dirname(__FILE__), './translator/message_parser')

module Translator
  class Receiver
    include MessageParser

    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def receive(sender, raw_package)
      package = parse_message(raw_package)
      route_message(package)
    end

    private
      def route_message(parsed_message)
        case parsed_message[:message_type]
        when :greetings
          @client.update_bros parsed_message["bros"]
        when :regular
          @client.message parsed_message["message"]
        end
      end
      #EOF private
  end

  class Sender
  end
end
