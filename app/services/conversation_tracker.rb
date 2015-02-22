class ConversationTracker
  def initialize(body, session)
    @body = body
    @session = session
    restart if @body =~ /\Areset\z/i
  end

  def restart
    @session[:counter] = 0
    @session[:zip] = false
  end

  def enable_second_step
    @session[:zip] = true
  end

  def first_step_message
    return process_valid_zip if @body =~ /\A\d{5}\z/
    'Please enter a valid 5-digit ZIP code'
  end

  def process_valid_zip
    enable_second_step
    'Here are 5 locations in your zip. Enter a number to choose.'
  end

  def second_step_message
    return process_valid_choice if @body =~ /\A[1-5]\z/
    'Please enter a number'
  end

  def process_valid_choice
    @session[:zip] = false
    "You chose #{@body}"
  end

  def first_step?
    @session[:counter] == 0 || !second_step?
  end

  def second_step?
    @session[:zip] == true
  end

  def message
    return first_step_message if first_step?
    return second_step_message if second_step?
  end
end
