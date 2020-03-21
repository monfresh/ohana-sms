# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.5.7'

gem 'faraday-http-cache', '~> 2.0'
gem 'figaro'
gem 'ohanakapa', '~> 1.1.1'
gem 'puma'
gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
gem 'twilio-ruby'

group :production do
  gem 'dalli'
  gem 'kgio'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'bummr'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'mocha'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'simplecov', '>= 0.17.1', require: false
  gem 'vcr'
  gem 'webmock'
end
