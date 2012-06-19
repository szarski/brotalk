class Bro
  attr_reader :address

  def initialize(address, supernode)
    @address = address
    @supernode = supernode
  end

  def supernode?
    @supernode
  end

  def self.from_json(table)
    table.map do |b|
      raise "incorrect Bro json description: #{b.inspect}" unless b =~ /[^%]+%[01]/
      self.new *b.split('%')
    end
  end

  def eql?(bro)
    bro.address.eql? self.address
  end

  def ==(bro)
    eql? bro
  end

  def eq?(bro)
    eql? bro
  end

  def hash
    address.hash
  end

  def to_json(*args)
    "#{address}%#{supernode? ? 1 : 0}"
  end

  def <=>(bro)
    address <=>bro.address
  end
end
