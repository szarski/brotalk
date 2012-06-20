class Client
  MAX_REGULAR_NODES = 5
  attr_reader :communicator, :translator_receiver, :translator_sender, :bros_table

  def initialize
    @bros_table = []
    @communicator = Communicator.new
    @translator_receiver = Translator::Receiver.new(self)
    @communicator.register_listener translator_receiver
    @translator_sender = Translator::Sender.new(communicator)
    @supernode = false
  end

  def start_listening
    communicator.start_listening
  end

  def update_bros(bros_table_update)
    new_bros_table = (@bros_table + bros_table_update).uniq
    new_entries = (new_bros_table - @bros_table)
    @bros_table = new_bros_table
    new_entries.each do |bro|
      greet_bro bro
    end
  end

  def greet_bro bro
    greet bro.address
  end

  def greet address
    translator_sender.greet address, bros_table
  end

  def supernode?
    @supernode
  end

  def elect!
    @supernode = true
  end

  def ensure_supernodes!
    if !supernode? and bros_table.select {|b| b.supernode?}.empty?
      elect!
    end
  end

  def clear_bro_table
    count_of_nodes_to_delete = bros_table.reject {|b| b.supernode?}.count - MAX_REGULAR_NODES
    if count_of_nodes_to_delete > 0
      @bros_table = @bros_table.delete_if {|bro| count_of_nodes_to_delete -=1; !bro.supernode? and count_of_nodes_to_delete >= 0}
    end
  end
end
