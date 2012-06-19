class Bro
  attr_reader :address

  def initialize(address, supernode)
    @address = address
    @supernode = supernode
  end

  def supernode?
    @supernode
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
end
