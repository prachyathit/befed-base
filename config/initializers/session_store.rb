
# Be sure to restart your server when you modify this file.

if Rails.env.production?
  # require 'action_dispatch/middleware/session/dalli_store'
  Rails.application.config.session_store  ActionDispatch::Session::CacheStore, namespace: 'sessions', key: '_befed_app_session', expire_after: 1.day
else
  Rails.application.config.session_store :cookie_store, key: '_befed_app_session'
end