require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  test 'should get reply' do
    get_reply_with_body('foo')
    assert_response :success
  end

  test 'sends a Twilio::TwiML::Response' do
    twiml = Twilio::TwiML::Response.new { |r| r.Message 'foo' }
    Twilio::TwiML::Response.expects(:new).returns(twiml)
    assert get_reply_with_body('boo')
  end

  test 'increments session counter by one' do
    get_reply_with_body('foo')
    assert_equal 1, session[:counter]
  end

  test 'asks for valid zip when body is empty' do
    get_reply_with_body('')
    assert_equal 'Please enter a valid 5-digit ZIP code', sms_body
  end

  test 'keeps asking for valid zip until body matches 5 digits' do
    get_reply_with_body('')
    get_reply_with_body('foo')
    assert_equal 'Please enter a valid 5-digit ZIP code', sms_body
  end

  test 'asks for valid zip when body is not 5 digits' do
    get_reply_with_body('foo')
    assert_equal 'Please enter a valid 5-digit ZIP code', sms_body
  end

  test 'does not set session[:start] when body is not 5 digits' do
    get_reply_with_body('foo')
    assert_equal nil, session[:start]
  end

  test 'returns locations when body matches 5 digits' do
    get_reply_with_body('94103')
    assert_match(/Here are 5 locations/, sms_body)
  end

  test 'sets session[:start] to false when body matches 5 digits' do
    get_reply_with_body('94103')
    assert_equal false, session[:start]
  end

  test 'sets session[:zip] to true when body matches 5 digits' do
    get_reply_with_body('94103')
    assert_equal true, session[:zip]
  end

  test 'asks for number when session[:zip] is true & body is not 1-5' do
    get_reply_with_body('94103')
    get_reply_with_body('foo')
    assert_equal 'Please enter a number', sms_body
  end

  test 'asks for number when session[:zip] is true & number out of range' do
    get_reply_with_body('94103')
    get_reply_with_body('10')
    assert_equal 'Please enter a number', sms_body
  end

  test 'returns number when session[:zip] is true & body is 1-5' do
    get_reply_with_body('94103')
    get_reply_with_body('2')
    assert_equal 'You chose 2', sms_body
  end

  test 'sets session[:zip] to false when body is 1-5' do
    get_reply_with_body('94103')
    get_reply_with_body('2')
    assert_equal false, session[:zip]
  end

  test 'sets session[:start] to true when body = reset' do
    get_reply_with_body('94103')
    get_reply_with_body('reset')
    assert_equal true, session[:start]
  end

  test 'resets session[:counter] to 0 when body = reset' do
    get_reply_with_body('94103')
    get_reply_with_body('reset')
    assert_equal 1, session[:counter]
  end

  test 'resets session[:counter] to 0 when body = Reset' do
    get_reply_with_body('94103')
    get_reply_with_body('Reset')
    assert_equal 1, session[:counter]
  end

  test 'does not reset session[:counter] when body is not exactly /reset/i' do
    get_reply_with_body('94103')
    get_reply_with_body('resetz')
    assert_equal 2, session[:counter]
  end

  private

  def get_reply_with_body(body)
    get :reply, 'Body' => body
  end
end
