class TwitterWrapper
  def initialize
    load_config
    @twitter = Twitter::Client.new
  end

  def scan_addresses(hashtag)
    twitter_messages = scan_twitter(hashtag)
    fetch_addresses(twitter_messages)
  end

  def publish_address(ip_address, hashtag)
    @twitter.update("And now something completly different "\
      "#{ip_address} ##{hashtag}")
  end

  private
    def scan_twitter(hashtag)
      @twitter.search("##{hashtag}").map(&:full_text)
    end

    def fetch_addresses(twitter_messages)
      twitter_messages.map{|mesg| mesg.scan(regexp)}.flatten.uniq
    end

    def regexp
      /(?:\d{1,3}\.){3}\d{1,3}/
    end

    def load_config
      twitter_config = YAML.load_file(File.join(File.dirname(__FILE__),
        "../config/twitter.yml"))
      Twitter.configure do |config|
        config.consumer_key = twitter_config["consumer_key"]
        config.consumer_secret = twitter_config["consumer_secret"]
        config.oauth_token = twitter_config["oauth_token"]
        config.oauth_token_secret = twitter_config["oauth_token_secret"]
      end
    end
  #EOF private
end
