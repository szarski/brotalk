require File.join(File.dirname(__FILE__), 'lib', 'brotalk')
require 'sinatra'
require 'drb'
DRb.start_service

def simulator
  DRbObject.new_with_uri('druby://localhost:9000')
end

def get_client_by_address(address)
  communicator = simulator.listeners[address]
  communicator.listeners.first.client
end

set :public_folder, 'web_interface'

get '/logs.json' do
  simulator.logs.to_json
end

get '/clients.json' do
  hashes = simulator.listeners.map do |address, communicator|
    {:address => address, :bros_table => get_client_by_address(address).bros_table.to_json, :supernode => get_client_by_address(address).supernode?}
  end
  hashes.to_json
end

get '/connections.json' do
  hashes = simulator.listeners.map do |address, communicator|
    [address, get_client_by_address(address).bros_table.map(&:address)]
  end
  hashes.to_json
end

get '/clients/:sender_address/greet/:receiver_address' do
  #puts(params[:sender_address].inspect, params[:receiver_address].inspect)
  simulator.greet(params[:sender_address], params[:receiver_address])
  "ok"
end

get "/" do
  redirect '/index.html'
end

