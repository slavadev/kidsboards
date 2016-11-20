require 'test_helper'

class User::RequestRecoveryTest < ActionDispatch::IntegrationTest
  test 'request recovery success' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }

    # register
    post '/v1/user/register', params: params

    # check results
    json = JSON.parse(response.body)
    id = json['id']
    user = User::User.find_by_id(id)
    params = { email: email }

    # action
    post '/v1/user/request', params: params

    # get code from email
    assert_response :success
    confirmation_email = ActionMailer::Base.deliveries.last
    text = confirmation_email.body.to_s
    string_to_find = ENV['SITE_RECOVERY_LINK'] + '/'
    regexp = Regexp.new(Regexp.escape(string_to_find) + '\w*')
    code = text.scan(regexp).first.to_s.gsub(string_to_find, '')

    # check token
    token = User::Token.where(code: code, token_type: User::Token::TYPE_RECOVERY).first
    assert_not_nil(token)
    token_user = token.user
    assert_equal token_user, user
  end

  test 'request recovery success with wrong email' do
    # prepare
    email = Faker::Internet.free_email
    params = { email: email }

    # action
    post '/v1/user/request', params: params

    # check results
    assert_response :success
  end

  test 'request recovery fail without email' do
    # action
    post '/v1/user/request'

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'is invalid'
    assert_includes json['email'], 'can\'t be blank'
  end
end
