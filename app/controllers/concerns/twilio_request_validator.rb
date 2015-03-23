module TwilioRequestValidator
  extend ActiveSupport::Concern

  included do
    before_action :validate_request
  end

  def validate_request
    return unless twilio_request?
  end

  def twilio_request?
    return true if Rails.env.test?
    validator.validate uri, twilio_params, signature
  end

  def validator
    Twilio::Util::RequestValidator.new(Figaro.env.twilio_auth_token)
  end

  def uri
    request.original_url
  end

  def twilio_params
    env['rack.request.query_hash']
  end

  def signature
    env['HTTP_X_TWILIO_SIGNATURE']
  end
end
