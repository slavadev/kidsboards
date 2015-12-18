require 'test_helper'

class User::LoginTest < ActionDispatch::IntegrationTest
  test 'login success' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/api/v1/user/register', params

    # action
    post '/api/v1/user/login', params

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    token = json['token']
    token = User::Token.where(code: token).first
    assert_equal token.user.email, email
    assert_equal token.is_expired, false
    assert_equal token.type, User::Token::TYPE_LOGIN
  end

  test 'login fail invalid params' do
    # prepare
    email = 'qwe'
    password = 'asd'
    params = { email: email, password: password }

    # action
    post '/api/v1/user/login', params

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'is invalid'
    assert_includes json['password'], 'is too short (minimum is 6 characters)'
  end

  test 'login fail without params' do
    # action
    post '/api/v1/user/login'

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'is invalid'
    assert_includes json['email'], 'can\'t be blank'
    assert_includes json['password'], 'is too short (minimum is 6 characters)'
    assert_includes json['password'], 'can\'t be blank'
  end

  test 'login fail wrong email' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/api/v1/user/register', params

    params['email'] = Faker::Internet.free_email
    # action
    post '/api/v1/user/login', params

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'Wrong email or password'
  end

  test 'login fail wrong password' do
    # prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/api/v1/user/register', params

    params['password'] = Faker::Internet.password
    # action
    post '/api/v1/user/login', params

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'Wrong email or password'
  end
end
