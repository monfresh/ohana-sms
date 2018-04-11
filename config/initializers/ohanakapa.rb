# frozen_string_literal: true

stack = Faraday::RackBuilder.new do |builder|
  builder.use :http_cache, store: Rails.cache, serializer: Marshal
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Ohanakapa.configure do |config|
  config.api_endpoint = ENV['OHANA_API_ENDPOINT']

  config.middleware = stack
end
