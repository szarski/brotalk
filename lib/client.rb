class Client
  attr_reader :communicator, :translator_receiver, :translator_sender, :bros_table

  def initialize
    @bros_table = []
    @communicator = Communicator.new
    @translator_receiver = Translator::Receiver.new(self)
    @communicator.register_listener translator_receiver
    @translator_sender = Translator::Sender.new(communicator)
  end

  def start_listening
    communicator.start_listening
  end

  def update_bros(bros_table_update)
    new_bros_table = (@bros_table + bros_table_update).uniq
    new_entries = (new_bros_table - @bros_table)
    @bros_table = new_bros_table
    new_entries.each do |bro|
      greet bro
    end
  end

  def greet receiver
    translator_sender.greet receiver, bros_table
  end
end
