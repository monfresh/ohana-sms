# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.3.3'

gem 'faraday-http-cache', '~> 2.0'
gem 'figaro'
gem 'ohanakapa', '~> 1.1.1'
gem 'puma'
gem 'rails', '~> 5.2.0'
gem 'twilio-ruby'

group :production do
  gem 'dalli'
  gem 'kgio'
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'bummr'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'mocha'
  gem 'rubocop'
  gem 'vcr'
  gem 'webmock'
end
