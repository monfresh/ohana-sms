# frozen_string_literal: true

class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_locale

  def reply
    session[:counter] ||= 0

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message(body: ConversationTracker.new(params[:Body], session).message)
    end

    session[:counter] += 1
    render xml: twiml.to_s
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
