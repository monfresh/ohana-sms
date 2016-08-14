# frozen_string_literal: true
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
    assert_equal t('intro'), sms_body
  end

  test 'keeps asking for valid zip until body matches 5 digits' do
    get_reply_with_body('')
    get_reply_with_body('foo')
    assert_equal t('intro'), sms_body
  end

  test 'asks for valid zip when body is not 5 digits' do
    get_reply_with_body('foo')
    assert_equal t('intro'), sms_body
  end

  test 'asks for category choice when body matches 5 digits' do
    get_reply_with_body('94103')
    assert_match(t('choose_category', list: '#1'), sms_body)
  end

  test 'returns numbered categories when body matches 5 digits' do
    get_reply_with_body('94103')
    assert_match(/#1: Care/, sms_body)
  end

  test 'asks for category when body matches 5 digits after initial SMS' do
    get_reply_with_body('foo')
    get_reply_with_body('94103')
    assert_match(t('choose_category', list: '#1'), sms_body)
  end

  test 'sets session[:zip] to the body when body matches 5 digits' do
    get_reply_with_body('94103')
    assert_equal '94103', session[:zip]
  end

  test 'sets session[:step_2] to true when body matches 5 digits' do
    get_reply_with_body('94103')
    assert_equal true, session[:step_2]
  end

  test 'looks for entered search term when on step 2 and body is not 1-11' do
    VCR.use_cassette('94103_calfresh', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('calfresh')
      assert_match(t('results_intro'), sms_body)
    end
  end

  test 'returns no results when on step 2 and search term has no matches' do
    VCR.use_cassette('94103_foobar', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('foobar')
      assert_equal t('no_results_found'), sms_body
    end
  end

  test 'returns 5 locations when category choice is 1-11' do
    VCR.use_cassette('94103_work', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('11')
      assert_match(t('results_intro'), sms_body)
    end
  end

  test 'does not duplicate location and org name if equal' do
    VCR.use_cassette('94103_emergency', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('3')
      refute_match(/Breast Cancer Emergency Fund \(Breast Cancer/, sms_body)
    end
  end

  test 'returns helpful message when no results are found' do
    VCR.use_cassette('94388_work', allow_playback_repeats: true) do
      get_reply_with_body('94388')
      get_reply_with_body('11')
      assert_equal t('no_results_found'), sms_body
    end
  end

  test 'resets conversation when no results are found' do
    VCR.use_cassette('94388_work', allow_playback_repeats: true) do
      get_reply_with_body('94388')
      get_reply_with_body('11')
      assert_equal false, session[:step_2]
      assert_equal false, session[:step_3]
      assert_equal 1, session[:counter]
    end
  end

  test 'sets session[:step_3] to true when category is 1-11' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      assert_equal true, session[:step_3]
    end
  end

  test 'sets session[:cats] to body before making API request' do
    VCR.use_cassette('94388_work', allow_playback_repeats: true) do
      get_reply_with_body('94388')
      get_reply_with_body('11')
      assert_equal '11', session[:cats]
    end
  end

  test 'sets session[:step_2] to false when category is 1-11' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      assert_equal false, session[:step_2]
    end
  end

  test 'returns location details when location choice is 1-5' do
    VCR.use_cassette('94103_food', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('4')
      get_reply_with_body('1')
      assert_match(/Phone:/, sms_body)
    end
  end

  test 'includes address in location details' do
    VCR.use_cassette('94103_food', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('4')
      get_reply_with_body('1')
      assert_match(/Address:/, sms_body)
    end
  end

  test 'includes address_2 in location details if present' do
    VCR.use_cassette('94402_ymca', allow_playback_repeats: true) do
      get_reply_with_body('94402')
      get_reply_with_body('ymca')
      get_reply_with_body('1')
      assert_match(/Suite 115/, sms_body)
    end
  end

  test 'asks for valid choice when body is not 1-5' do
    VCR.use_cassette('94103_food', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('4')
      get_reply_with_body('6')
      assert_equal t('choose_location'), sms_body
    end
  end

  test 'leaves session[:step_2] set to false when location is 1-5' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('4')
      assert_equal false, session[:step_2]
    end
  end

  test 'leaves session[:step_3] set to true when location is 1-5' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('4')
      assert_equal true, session[:step_3]
    end
  end

  test 'sets session[:location] to body when location is 1-5' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('4')
      assert_equal '4', session[:location]
    end
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
    VCR.use_cassette('94103_computer', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('computer')
      assert_equal 2, session[:counter]
    end
  end

  test 'asks for a location number if the conversation is not reset' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('3')
      get_reply_with_body('foo')
      assert_equal t('choose_location'), sms_body
    end
  end

  test 'responds with welcome if user says thanks' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('3')
      get_reply_with_body('thanks!')
      assert_equal "#{t('you_are_welcome')} #{t('choose_location')}", sms_body
    end
  end

  test 'responds with welcome if user says thank you' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('3')
      get_reply_with_body('thank you')
      assert_equal "#{t('you_are_welcome')} #{t('choose_location')}", sms_body
    end
  end

  test 'responds with welcome if user says ty' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('3')
      get_reply_with_body('ty')
      assert_equal "#{t('you_are_welcome')} #{t('choose_location')}", sms_body
    end
  end

  test 'returns details for different location when new number is entered' do
    VCR.use_cassette('94103_education', allow_playback_repeats: true) do
      get_reply_with_body('94103')
      get_reply_with_body('2')
      get_reply_with_body('3')
      first_phone = sms_body.delete('^0-9')
      get_reply_with_body('5')
      second_phone = sms_body.delete('^0-9')
      refute_equal first_phone, second_phone
    end
  end

  test 'resets the conversation if interrupted before the end' do
    get_reply_with_body('94103')
    get_reply_with_body('reset')
    assert_equal t('intro'), sms_body
  end

  test 'sets session[:step_2] to false when the conversation is reset' do
    get_reply_with_body('94103')
    get_reply_with_body('reset')
    assert_equal false, session[:step_2]
  end

  test 'tracks conversation from beginning to end' do
    VCR.use_cassette('94103_hi', allow_playback_repeats: true) do
      get_reply_with_body('hi')
      get_reply_with_body('94103')
      get_reply_with_body('hi')
      get_reply_with_body('2')
      get_reply_with_body('5')
      assert_match(/Phone:/, sms_body)
    end
  end

  test 'tracks conversation after reset' do
    VCR.use_cassette('94103_hello', allow_playback_repeats: true) do
      get_reply_with_body('hi')
      get_reply_with_body('94103')
      get_reply_with_body('hello')
      get_reply_with_body('reset')
      get_reply_with_body('foo')
      assert_equal t('intro'), sms_body
    end
  end

  test 'uses Spanish when locale params is set to es' do
    get_reply_with_body('', 'es')
    assert_match(/Hola/, sms_body)
    get_reply_with_body('94103', 'es')
    assert_match(/elija una categoría/, sms_body)
  end

  test 'uses English category names for API search' do
    VCR.use_cassette('94103_care', allow_playback_repeats: true) do
      get_reply_with_body('', 'es')
      get_reply_with_body('94103', 'es')
      get_reply_with_body('1', 'es')
      assert_match(/Aquí hay hasta/, sms_body)
    end
  end

  test 'validate_request' do
    @request.stubs(:headers).returns('HTTP_X_TWILIO_SIGNATURE' => 'foo')
    Figaro.env.stubs(:VALIDATE_REQUEST).returns('true')

    get :reply
    assert_response :unauthorized
  end

  private

  def get_reply_with_body(body, locale = 'en')
    get :reply, 'Body' => body, locale: locale
  end
end
