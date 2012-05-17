require 'json'

module Translator
  class Receiver
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def receive(sender, package)
      package = JSON.parse(package)
      if package["message"] == "ay bro"
        @client.update_bros package["bros"]
      end
    end
  end

  class Sender
  end
end
