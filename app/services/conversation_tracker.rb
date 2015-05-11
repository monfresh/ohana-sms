class ConversationTracker
  def initialize(body, session)
    @body = body
    @session = session
    restart if @body =~ /\Areset\z/i
  end

  def restart
    @session[:counter] = 0
    @session[:step_2] = false
    @session[:step_3] = false
  end

  def enable_second_step
    @session[:step_2] = true
    @session[:zip] = @body
  end

  def first_step_message
    return process_valid_zip if @body =~ /\A\d{5}\z/
    I18n.t('intro')
  end

  def process_valid_zip
    enable_second_step
    Messenger.new(nil).categories
  end

  def second_step_message
    @session[:cats] = @body
    return apologize_and_restart if no_results?
    enable_third_step
    Messenger.new(@session).search_results
  end

  def no_results?
    Messenger.new(@session).locations.blank?
  end

  def apologize_and_restart
    restart
    I18n.t('no_results_found')
  end

  def enable_third_step
    @session[:step_2] = false
    @session[:step_3] = true
  end

  def third_step_message
    return process_location_details if @body =~ /\A[1-5]\z/
    if @body =~ /ty\z|thanks!?\z|thank you!*\z/i
      return "#{I18n.t('you_are_welcome')} #{I18n.t('choose_location')}"
    end
    I18n.t('choose_location')
  end

  def process_location_details
    @session[:location] = @body
    Messenger.new(@session).location_details
  end

  def first_step?
    @session[:counter] == 0 || (!second_step? && !third_step?)
  end

  def second_step?
    @session[:step_2] == true
  end

  def third_step?
    @session[:step_3] == true
  end

  def message
    return first_step_message if first_step?
    return second_step_message if second_step?
    return third_step_message if third_step?
  end
end
