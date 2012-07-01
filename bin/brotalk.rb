##! /bin/ruby
require File.join(File.dirname(__FILE__), "../lib/brotalk.rb")

client = Client.new
client.start_listening
if address = ARGV[0]
  client.greet(address)
end

loop { sleep(5); puts "Bros_table: #{client.bros_table}"}
