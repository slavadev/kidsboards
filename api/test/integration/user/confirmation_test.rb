require 'test_helper'

class User::ConfirmationTest < ActionDispatch::IntegrationTest
  test 'confirm success' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }

    # register
    post '/api/v1/user/register', params
    json = JSON.parse(response.body)
    id = json['id']

    # get code from email
    confirmation_email = ActionMailer::Base.deliveries.last
    text = confirmation_email.body.to_s
    string_to_find = ENV['SITE_HOST'] + '/api/v1/user/confirm/'
    regexp = Regexp.new(Regexp.escape(string_to_find) + '\w*')
    code = text.scan(regexp).first.to_s.gsub(string_to_find, '')

    # check token
    get '/api/v1/user/confirm/' + code
    assert_response :success
    token = User::Token.where(code: code, token_type: User::Token::TYPE_CONFIRMATION).first
    user = User::User.find(id)
    assert_equal token.is_expired, true
    assert_not_nil user.confirmed_at
  end

  test 'confirm fail wrong token' do
    # prepare
    code = Faker::Lorem.characters(10)

    # check token
    get '/api/v1/user/confirm/' + code
    assert_response 401
  end
end
