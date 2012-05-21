require "json"

class MessageBuilderError < StandardError;end

module MessageBuilder
  def build_message(message_type, message_body)
    prepare_message(message_type, message_body).to_json
  end

  def prepare_message(message_type, message_body)
    case message_type
    when :greeting
      {"message" => "ay bro", "bros_table" => message_body}
    when :regular
      {"message" => message_body}
    else
      raise MessageBuilderError, "Unknown message type."
    end
  end
end
