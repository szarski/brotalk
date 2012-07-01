require "json"

class MessageBuilderError < StandardError;end

module MessageBuilder
  def build_message(message_type, message_body=nil)
    prepare_message(message_type, message_body).to_json
  end

  def prepare_message(message_type, message_body=nil)
    case message_type
    when :greeting
      {
        "message" => "ay bro",
        "bros_table" => message_body[:bros_table],
        "supernode" => (message_body[:supernode] ? 1 : 0)
      }
    when :regular
      {"message" => message_body}
    when :ping
      {"message" => "ping"}
    when :pong
      {"message" => "pong"}
    else
      raise MessageBuilderError, "Unknown message type."
    end
  end
end
