class Parser
  attr_reader :parent

  def initialize(parent)
    @parent = parent
  end

  def react(sender, message)
    if message == "ay bro"
      parent.register_peer sender
      return "ay"
    else
      return "u mad bro"
    end
  end
end
