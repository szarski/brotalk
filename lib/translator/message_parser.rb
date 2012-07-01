require 'json'

module MessageParser
  def parse_message(raw_message)
    parsed_message = self.parse_json(raw_message)
    if parsed_message["message"] == "ay bro"
      parsed_message[:message_type] = :greetings
    elsif parsed_message["message"] == "ping"
      parsed_message[:message_type] = :ping
    elsif parsed_message["message"] == "pong"
      parsed_message[:message_type] = :pong
    elsif parsed_message["message"].nil?
      parsed_message[:message_type] = :broken
    else
      parsed_message[:message_type] = :regular
    end
    parsed_message
  end

  def parse_json(raw_message)
    JSON.parse(raw_message)
  rescue JSON::ParserError
    #broken message, return empty hash
    {}
  end
end
