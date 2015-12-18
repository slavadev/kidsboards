require 'test_helper'

class User::ViewTest < ActionDispatch::IntegrationTest

  test 'view success' do
    # prepare
    ## Register and login
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/api/v1/user/register', params
    post '/api/v1/user/login', params
    json = JSON.parse(response.body)
    token = json['token']
    ## Family
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put '/api/v1/family', token: token, name: name, photo_url: photo_url

    # action
    get '/api/v1/user', token: token

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    ## checks user
    assert_equal email, json['email']
    assert_nil json['created_at']
    assert_nil json['encrypted_password']
    ## checks family
    assert_equal name, json['family']['name']
    assert_equal photo_url, json['family']['photo_url']

  end


  test 'view fail with wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)

    # action
    get '/api/v1/user', token: token

    # check results
    assert_response 401
  end

  test 'view fail without token' do
    # action
    get '/api/v1/user'

    # check results
    assert_response 401
  end
end
