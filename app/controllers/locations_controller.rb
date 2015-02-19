class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def notify
    twilio_service = TwilioService.new
    message = twilio_service.send_sms(
      to: '+12225555555',
      body: 'Learning to send SMS you are.'
    )

    render plain: message.status
  end

  def reply
    twiml = Twilio::TwiML::Response.new do |r|
      r.Message message_for(params[:Body])
    end
    render xml: twiml.text
  end

  def message_for(zip)
    if zip =~ /\A\d{5}\z/
      "You entered #{zip}"
    else
      "Please enter a valid 5-digit ZIP code"
    end
  end
end
