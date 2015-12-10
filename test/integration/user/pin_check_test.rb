require 'test_helper'

class User::PinCheckTest < ActionDispatch::IntegrationTest
  test 'pin check success' do
    # prepare
    token = login
    pin = Faker::Number.number(4).to_s
    patch '/api/v1//user/pin', token: token, pin: pin

    # action
    get '/api/v1//user/pin', token: token, pin: pin

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal json['equal'], true
  end

  test 'pin check wrong params' do
    # prepare
    token = login

    # action 1
    pin = Faker::Number.number(3).to_s
    patch '/api/v1//user/pin', token: token, pin: pin

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['pin'], 'is the wrong length (should be 4 characters)'

    # action 2
    pin = Faker::Number.number(5).to_s
    patch '/api/v1//user/pin', token: token, pin: pin

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['pin'], 'is the wrong length (should be 4 characters)'

    # action 3
    pin = '00a0'
    patch '/api/v1//user/pin', token: token, pin: pin

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['pin'], 'has wrong format'

    # action 4
    patch '/api/v1//user/pin', token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['pin'], 'has wrong format'
  end

  test 'pin check fail wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)

    # action
    pin = Faker::Number.number(4).to_s
    get '/api/v1//user/pin', token: token, pin: pin

    # check results
    assert_response 401
  end

  test 'pin check fail without token' do
    # action
    pin = Faker::Number.number(4).to_s
    get '/api/v1//user/pin', pin: pin

    # check results
    assert_response 401
  end
end
