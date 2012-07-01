class Client
  # oneself may be counted in here
  MAX_REGULAR_NODES = 2
  ZOMBIE_KILL_LIMIT = 10
  ZOMBIE_CHECK_LIMIT = 5
  attr_reader :communicator, :translator_receiver, :translator_sender, :bros_table, :thread

  def initialize
    @bros_table = []
    @communicator = Communicator::DEFAULT_CLASS.new
    @translator_receiver = Translator::Receiver.new(self)
    @communicator.register_listener translator_receiver
    @translator_sender = Translator::Sender.new(communicator)
    @supernode = false
    c = self
    @thread = Thread.new do 
      loop do
        begin
        sleep(3)
        c.periodically
        rescue => e
          puts e.to_s
          puts e.backtrace
        end
      end
    end
  end

  def periodically
    clear_bro_table
    ping_bros
  end

  def start_listening
    communicator.start_listening
  end

  def update_bros(bros_table_update, sender_address)
    new_bros_table = (@bros_table + bros_table_update).uniq
    new_entries = (new_bros_table - @bros_table)
    @bros_table = new_bros_table
    update_last_activity!(sender_address)
    ensure_supernodes!
    new_entries.each do |bro|
      greet_bro bro
    end
  end

  def greet_bro bro
    greet bro.address
  end

  def greet address
    translator_sender.greet address, bros_table, supernode?
  end

  def pong(sender)
    translator_sender.pong(sender)
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
    if !supernode? and count_of_nodes_to_delete > 0
      @bros_table = @bros_table.delete_if do |bro|
        d=(!bro.supernode? and count_of_nodes_to_delete >= 0)
        if d
          count_of_nodes_to_delete -=1;
        end
        d
      end
    end
  end

  def update_last_activity!(sender_address)
    @bros_table.each_with_index do |entry, index|
      if entry.address == sender_address 
        @bros_table[index].last_activity = Time.now.to_i
      end
    end
  end

  private
    def ping_bros
      @bros_table.each_with_index do |bro, index|
        last_activity_relatvie = Time.now.to_i - bro.last_activity
        if last_activity_relatvie > ZOMBIE_KILL_LIMIT
          @bros_table.delete_at(index)
        elsif last_activity_relatvie > ZOMBIE_CHECK_LIMIT
          is_alive?(bro)
        end
      end
    end

    def is_alive?(bro)
      translator_sender.ping(bro.address)
    end
    #EOF private
end
