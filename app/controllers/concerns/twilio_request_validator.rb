module TwilioRequestValidator
  extend ActiveSupport::Concern

  included do
    before_action :validate_request, if: :validations_enabled?
  end

  def validate_request
    return if twilio_request?
    render text: 'Twilio request signature verification failed.',
           status: :unauthorized
  end

  def twilio_request?
    validator.validate uri, twilio_params, signature
  end

  def validator
    Twilio::Util::RequestValidator.new(Figaro.env.TWILIO_AUTH_TOKEN)
  end

  def uri
    request.original_url
  end

  def twilio_params
    request.request_parameters
  end

  def signature
    request.headers['HTTP_X_TWILIO_SIGNATURE']
  end

  private

  def validations_enabled?
    Figaro.env.VALIDATE_REQUEST
  end
end
