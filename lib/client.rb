class Client
  attr_reader :communicator, :translator_receiver, :translator_sender

  def initialize
    @communicator = Communicator.new
    @translator_receiver = Translator::Receiver.new(self)
    @communicator.register_listener translator_receiver
    @translator_sender = Translator::Sender.new(communicator)
  end
end
