require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-status'
require 'sidekiq-status/web'
rails_root = Rails.root || File.dirname(__FILE__) + "/../.."
rails_env = Rails.env || "development"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes

  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|

  if Rails.env.development?
    [user, password] == ['test', 'test']
	end
	
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