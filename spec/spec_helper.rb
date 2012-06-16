require File.join(File.dirname(__FILE__), '..', 'lib', 'brotalk')

def let_mocks(*names)
  names.each do |name|
    let(name) {mock}
  end
end
