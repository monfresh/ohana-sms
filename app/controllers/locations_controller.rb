class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reply
    session[:counter] ||= 0

    twiml = Twilio::TwiML::Response.new do |r|
      r.Message ConversationTracker.new(params[:Body], session).message
    end

    session[:counter] += 1
    render xml: twiml.text
  end
end
