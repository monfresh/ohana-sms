class TwilioService
  def initialize
    twilio_client
  end

  def twilio_client
    @client ||= Twilio::REST::Client.new(
      Figaro.env.twilio_account_sid,
      Figaro.env.twilio_auth_token
    )
  end

  def send_sms(params = {})
    params = params.reverse_merge(from: Figaro.env.twilio_number)
    @client.messages.create(params)
  end
end