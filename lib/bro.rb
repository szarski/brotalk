class Bro
  attr_reader :address

  def initialize(address, supernode)
    @address = address
    @supernode = supernode
  end

  def supernode?
    @supernode
  end
end
