class Client
  attr_reader :communicator, :translator_receiver, :translator_sender, :bros_table

  def initialize
    @communicator = Communicator.new
    @translator_receiver = Translator::Receiver.new(self)
    @communicator.register_listener translator_receiver
    @translator_sender = Translator::Sender.new(communicator)
  end

  def start_listening
    communicator.start_listening
  end

  def update_bros(bros_table_update)
    @bros_table = (@bros_table + bros_table_update).uniq
    @bros_table.each do |bro|
      translator = Translator::Sender.new(@communicator)
      translator.greet(bro, @bros_table)
    end
  end
end
