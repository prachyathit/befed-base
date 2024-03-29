source 'https://rubygems.org'
ruby '2.3.0'
gem 'rails', '4.2.2'
gem 'bcrypt', '3.1.7'
gem 'faker', '1.4.2'
gem 'will_paginate', '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'bootstrap-sass', '3.2.0.0'
gem 'sass-rails', '5.0.2'
gem 'uglifier', '2.5.3'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks', '2.3.0'
gem 'jbuilder', '2.2.3'
gem 'geocoder', '~> 1.3.6'
gem 'geocomplete_rails', '~> 1.7.0'
gem 'sdoc', '0.4.0', group: :doc

# for charting
gem "chartkick"
gem 'groupdate', '~> 2.1.1'
gem 'active_median', '~> 0.1.0'

# for icons
gem 'font-awesome-sass', '~> 4.6.2'

# payment
gem 'omise', github: 'omise/omise-ruby'

gem 'figaro'

# for MemCache
gem 'dalli'
gem 'connection_pool'

# for API
gem 'rails-api'
gem 'rails_param'
gem 'active_model_serializers', '~> 0.10.0'

# for monitoring
gem 'newrelic_rpm'

group :development, :test do
  gem 'sqlite3', '1.3.9'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'byebug', '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring', '1.1.3'
end

group :development, :staging do
  gem "better_errors"
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace', '0.1.3'
  gem 'guard-minitest', '2.3.1'
end

group :production do
  gem 'pg', '0.17.1'
  gem 'rails_12factor', '0.0.2'
  gem 'puma', '2.11.1'
end
