ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
include AbstractController::Translation

module ActiveSupport
  class TestCase
    def sms_body
      @sms_body = Nokogiri::XML(response.body).at_xpath('//Message').content
    end
  end
end
