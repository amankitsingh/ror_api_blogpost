source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 7.0.4", ">= 7.0.4.1"
gem "pg", "~> 1.4" # Pg is the Ruby interface to the PostgreSQL RDBMS
gem "pg_query", ">= 0.9.0" # Allows PGHero to analyze queries
gem "pg_search", "~> 2.3.6" # PgSearch builds Active Record named scopes that take advantage of PostgreSQL's full text search
gem "pghero", "~> 3.1" # Dashboard for Postgres
gem "puma", "~> 5.6.4" # Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server
gem "redis", "~> 4.7.1" # Redis ruby client , Use Redis adapter to run Action Cable in production
gem "redis-actionpack", "~> 5.3.0" # Redis session store for ActionPack. Used for storing the Rails session in Redis.
gem "sidekiq", "~> 6.5.3" # Sidekiq is used to process background jobs with the help of Redis
gem "strong_migrations", "~> 1.2" # Catch unsafe migrations
gem "warning", "~> 1.3" # Adds custom processing for warnings, including the ability to ignore specific warning messages
# gem "s3_direct_upload", "~> 0.1" # Direct Upload to Amazon S3
# gem "image_processing", "~> 1.2" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "fog-aws", "~> 3.14" # 'fog' gem to support Amazon Web Services
gem "devise", "~> 4.8" # Flexible authentication solution for Rails
gem "devise_invitable", "~> 2.0.6" # Allows invitations to be sent for joining
gem "email_validator", "~> 2.2" # Email validator for Rails and ActiveModel
gem "fastly", "~> 3.0" # Client library for the Fastly acceleration system
gem "rack-cors", "~> 1.1" # Middleware that will make Rack-based apps CORS compatible
gem "rack-timeout", "~> 0.6" # Rack middleware which aborts requests that have been running for longer than a specified timeout
gem "ransack", "~> 3.2" # Searching and sorting
gem "active_record_union", "~> 1.3" # Adds proper union and union_all methods to ActiveRecord::Relation
gem "bootsnap", ">= 1.1.0", require: false # Boot large ruby/rails apps faster
gem "devise", "~> 4.8" # Flexible authentication solution for Rails
gem 'grape', '~> 1.7', '>= 1.7.1'
group :development, :test do
  gem "better_errors", "~> 2.9" # Provides a better error page for Rails and other Rack apps
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "byebug", ">= 1.0.0" # Provide a debug with step capabilities
  gem "dotenv-rails", "~> 2.8.1" # For loading ENV variables locally
  gem "faker", "~> 2.22" # A library for generating fake data such as names, addresses, and phone numbers
  gem "pry", "~> 0.14" # An IRB alternative and runtime developer console
  gem "pry-rails", "~> 0.3" # Use Pry as your rails console
end

