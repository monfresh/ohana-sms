def cache_store
  return Rails.cache unless Rails.env.production?
  ActiveSupport::Cache.lookup_store(:dalli_store)
end

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, store: cache_store, serializer: Marshal
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Ohanakapa.configure do |config|
  config.api_endpoint = ENV['OHANA_API_ENDPOINT']

  config.middleware = stack
end
