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

get '/clients.json' do
  hashes = simulator.listeners.map do |address, communicator|
    {:address => address, :bros_table => get_client_by_address(address).bros_table.to_json}
  end
  hashes.to_json
end

get '/clients/:address/call/:method_name/:arguments' do
  simulator.greet(params[:address], params[:arguments])
  "ok"
end

get "/" do
  redirect '/index.html'
end

