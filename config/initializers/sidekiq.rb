require 'sidekiq'
require 'sidekiq/web'
# rails_root = Rails.root || File.dirname(__FILE__) + "/../.."
rails_env = Rails.env || "development"

sidekiq_config = { url: "redis://redis:6379", port: '6379' }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ['test', 'test']	
end
#CHECK ANKIT
Sidekiq.configure_server do |config|
  config.log_formatter = Sidekiq::Logger::Formatters::JSON.new
end
# with this we can see the dead jobs which can be mailed to us to send a message
# Sidekiq.configure_server do |config|
#   config.death_handlers << ->(job, ex) do
#     puts "Uh oh, #{job['class']} #{job["jid"]} just died with error #{ex.message}."
#   end
# end