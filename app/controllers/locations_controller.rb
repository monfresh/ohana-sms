class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reply
    session[:counter] ||= 0

    if params[:Body] =~ /reset/i
      session[:counter] = 0
      session[:start] = 'true'
    end

    if session[:counter] == 0 || session[:start] == 'true'
      if params[:Body] =~ /\A\d{5}\z/
        message = 'Here are 5 locations in your zip. Enter a number to choose.'
        session[:zip] = 'true'
        session[:start] = 'false'
      else
        message = 'Please enter a valid 5-digit ZIP code'
      end
    elsif session[:zip] == 'true'
      if params[:Body] =~ /\A[1-5]\z/
        message = "You chose #{params[:Body]}"
        session[:zip] = 'false'
      else
        message = 'Please enter a number'
      end
    else
      message = 'Please enter a valid 5-digit ZIP code'
    end

    twiml = Twilio::TwiML::Response.new do |r|
      r.Message message
    end

    session[:counter] += 1
    render xml: twiml.text
  end
end
