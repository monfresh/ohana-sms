# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.3'

gem 'faraday-http-cache', '~> 2.0'
gem 'figaro'
gem 'ohanakapa', '~> 1.1.1'
gem 'puma', '~> 5.3.1'
gem 'rails', '~> 5.2.6'
gem 'twilio-ruby', '>= 5.51.0'

group :production do
  gem 'dalli'
  gem 'kgio'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'bummr'
end

group :test do
  gem 'mocha'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end
