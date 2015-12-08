require 'test_helper'

class User::RecoveryTest < ActionDispatch::IntegrationTest
  test 'recovery success' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }

    # register
    post '/api/v1/user/register', params

    # check results
    params = { email: email }

    # action
    post '/api/v1/user/request', params

    # get code from email
    confirmation_email = ActionMailer::Base.deliveries.last
    text = confirmation_email.body.to_s
    string_to_find = ENV['SITE_RECOVERY_LINK'] + '/'
    regexp = Regexp.new(Regexp.escape(string_to_find) + '\w*')
    code = text.scan(regexp).first.to_s.gsub(string_to_find, '')

    # check token
    password = Faker::Internet.password
    params = { password: password, token: code }
    post '/api/v1/user/recovery', params
    assert_response :success
    token = User::Token.where(code: code, type: User::Token::TYPE_RECOVERY).first
    assert_equal token.is_expired, true

    # check new password
    params = { email: email, password: password }
    post '/api/v1//user/login', params

    # check results
    assert_response 200
  end

  test 'recovery fail wrong password' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }

    # register
    post '/api/v1/user/register', params

    # check results
    params = { email: email }

    # action
    post '/api/v1/user/request', params

    # get code from email
    confirmation_email = ActionMailer::Base.deliveries.last
    text = confirmation_email.body.to_s
    string_to_find = ENV['SITE_RECOVERY_LINK'] + '/'
    regexp = Regexp.new(Regexp.escape(string_to_find) + '\w*')
    code = text.scan(regexp).first.to_s.gsub(string_to_find, '')

    # check token
    password = 'asd'
    params = { password: password, token: code }
    post '/api/v1/user/recovery', params

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['password'], 'is too short (minimum is 6 characters)'

    # check token
    params = { token: code }
    post '/api/v1/user/recovery', params

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['password'], 'can\'t be blank'
  end

  test 'recovery fail without token' do
    post '/api/v1/user/recovery'

    # check results
    assert_response 401
  end
end
