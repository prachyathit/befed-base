
# Be sure to restart your server when you modify this file.

if Rails.env.production?
  require 'action_dispatch/middleware/session/dalli_store'
  Rails.application.config.session_store  ActionDispatch::Session::CacheStore, 
    namespace: 'sessions', 
    key: '_befed_app_session', 
    expire_after: 1.day
  # Rails.application.config.session_store :dalli_store,
  #   memcache_server: ENV["MEMCACHEDCLOUD_SERVERS"].split(','), 
  #   { :username => ENV["MEMCACHEDCLOUD_USERNAME"], :password => ENV["MEMCACHEDCLOUD_PASSWORD"] }
  #   namespace: 'sessions', 
  #   key: '_befed_app_session',
  #   expire_after: 1.day
else
  Rails.application.config.session_store :cookie_store, key: '_befed_app_session'
end