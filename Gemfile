# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 4.2.0'
gem 'figaro'
gem 'puma'
gem 'twilio-ruby'
gem 'ohanakapa', '~> 1.1.1'
gem 'faraday-http-cache', '~> 1.0'

group :production do
  gem 'dalli'
  gem 'kgio'
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'bummr'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'rubocop'
  gem 'mocha'
  gem 'vcr'
  gem 'webmock'
end
