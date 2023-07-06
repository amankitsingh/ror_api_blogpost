require 'sidekiq/web'
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_index_key_session"
Rails.application.routes.draw do
  root "welcome#show"
  
  mount Sidekiq::Web => "/sidekiq"

  mount Index::Base => "/"
  
end
