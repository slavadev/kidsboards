require 'test_helper'

class User::UserControllerTest < ActionController::TestCase

  test 'logout success' do
    #prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = {email: email, password: password}
    post :register, params
    post :login, params
    json = JSON.parse(response.body)
    token = json['token']

    #action
    post :logout, {token: token}

    #check results
    assert_response 204
    token = User::Token.where(code: token).first
    assert_equal token.user.email, email
    assert_equal token.is_expired, true
  end

  test 'logout fail without params' do
    #action
    post :logout

    #check results
    assert_response 401
  end

  test 'logout fail wrong token' do
    #action
    post :logout, {token: Faker::Lorem.characters(10)}

    #check results
    assert_response 401
  end
end