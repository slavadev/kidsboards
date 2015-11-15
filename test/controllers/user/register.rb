require 'test_helper'

class User::UserControllerTest < ActionController::TestCase

  test 'success register user' do
    #prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = {email: email, password: password}

    #action
    post :register, params

    #check results
    assert_response :success
    json = JSON.parse(response.body)
    id = json['_id']['$oid']
    user = User::User.find(id)
    assert_not_nil user, 'The user does not exist'
    assert_equal user.email, email, 'Wrong email'
  end

  test 'fail invalid params' do
    #prepare
    email = 'qwe'
    password = 'asd'
    params = {email: email, password: password}

    #action
    post :register, params

    #check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'is invalid'
    assert_includes json['password'], 'is too short (minimum is 6 characters)'
  end

  test 'fail without params' do
    #action
    post :register

    #check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'is invalid'
    assert_includes json['email'], 'can\'t be blank'
    assert_includes json['password'], 'is too short (minimum is 6 characters)'
    assert_includes json['password'], 'can\'t be blank'
  end

  test 'fail email exists' do
    #prepare
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = {email: email, password: password}
    post :register, params

    #action
    post :register, params

    #check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['email'], 'User already exists'
  end
end