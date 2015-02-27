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
    'Please enter a valid 5-digit ZIP code'
  end

  def process_valid_zip
    enable_second_step
    Messenger.new(nil).categories
  end

  def second_step_message
    return process_category_choice if @body =~ /\A([1-9]|1[0-1])\z/
    'Please enter a number between 1 and 11'
  end

  def process_category_choice
    return apologize_and_restart if no_results?
    enable_third_step
    Messenger.new(@session).search_results
  end

  def no_results?
    Messenger.new(@session).locations.blank?
  end

  def apologize_and_restart
    restart
    'Sorry, no results found.'
  end

  def enable_third_step
    @session[:step_2] = false
    @session[:step_3] = true
    @session[:cats] = @body
  end

  def third_step_message
    return process_location_details if @body =~ /\A[1-5]\z/
    'Please enter a number between 1 and 5'
  end

  def process_location_details
    @session[:location] = @body
    @session[:step_2] = false
    @session[:step_3] = false
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
