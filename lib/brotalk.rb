require 'twitter'
require File.join(File.dirname(__FILE__), 'translator')
require File.join(File.dirname(__FILE__), 'communicator')

module Brotalk

end

TWITTER_CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), '..', 'config', 'twitter.yml')))
Twitter.configure do |config|
  config.consumer_key = TWITTER_CONFIG['consumer_key']
  config.consumer_secret = TWITTER_CONFIG['consumer_secret']
  config.oauth_token = TWITTER_CONFIG['oauth_token']
  config.oauth_token_secret = TWITTER_CONFIG['oauth_token_secret']
end
