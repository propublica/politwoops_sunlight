cfg = YAML.load_file "#{Rails.root}/config/config.yml"
$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = cfg[:twitter][:consumer_key]
  config.consumer_secret = cfg[:twitter][:consumer_secret]
  config.oauth_token = cfg[:twitter][:oauth_token]
  config.oauth_token_secret = cfg[:twitter][:oauth_token_secret]
end
