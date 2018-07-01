# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'test/support/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'
end

module ActiveSupport
  class TestCase
    include AbstractController::Translation

    def sms_body
      @sms_body = Nokogiri::XML(response.body).at_xpath('//Message').content
    end
  end
end
