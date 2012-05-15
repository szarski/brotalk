module Translator
  class Receiver
    require 'json'
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def receive(sender, package)
      package = JSON.parse(package)#.symbolize_keys
      if package["message"] == "ay bro"
        client.update_bros package["bros"]
      end
    end
  end

  class Sender
  end
end
