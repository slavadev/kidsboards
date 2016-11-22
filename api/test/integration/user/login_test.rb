require 'test_helper'

class User::LoginTest < ActionDispatch::IntegrationTest
  test 'login success' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/v1/user/register', params: params

    # action
    post '/v1/user/login', params: params

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    token = json['token']
    token = User::Token.where(code: token).first
    assert_equal token.user.email, email
    assert_equal token.is_expired, false
    assert_equal token.token_type, User::Token::TYPE_LOGIN
  end

  test 'login fail invalid params' do
    # prepare
    email = 'qwe'
    password = 'asd'
    params = { email: email, password: password }

    # action
    post '/v1/user/login', params: params

    # check results
    assert_response 401
    json = JSON.parse(response.body)
    assert_equal json['error'], 'Wrong email or password'
  end

  test 'login fail without params' do
    # action
    post '/v1/user/login'

    # check results
    assert_response 401
    json = JSON.parse(response.body)
    assert_equal json['error'], 'Wrong email or password'
  end

  test 'login fail wrong email' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/v1/user/register', params: params

    params['email'] = Faker::Internet.free_email
    # action
    post '/v1/user/login', params: params

    # check results
    assert_response 401
    json = JSON.parse(response.body)
    assert_equal json['error'], 'Wrong email or password'
  end

  test 'login fail wrong password' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/v1/user/register', params: params

    params['password'] = Faker::Internet.password
    # action
    post '/v1/user/login', params: params

    # check results
    assert_response 401
    json = JSON.parse(response.body)
    assert_equal json['error'], 'Wrong email or password'
  end
end
