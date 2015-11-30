require 'test_helper'

class File::PhotoDeleteTest < ActionDispatch::IntegrationTest

  test 'photo delete success' do
    #prepare
    token = login

    file = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    post '/api/v1/file/photo', {token: token, file: file}
    json = JSON.parse(response.body)
    url = json['url']

    #action
    delete '/api/v1/file/photo', {token: token, url: url}

    #check results
    assert_response 204
    photo = File::Photo.where(url: url).first
    assert_not_equal nil, photo.deleted_at
  end

  test 'photo delete wrong users photo' do
    #prepare
    token = login

    file = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    post '/api/v1/file/photo', {token: token, file: file}
    json = JSON.parse(response.body)
    url = json['url']
    token = login

    #action
    delete '/api/v1/file/photo', {token: token, url: url}

    #check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['url'], 'not exists'
  end

  test 'photo delete wrong params' do
    #prepare
    token = login

    #action 1
    url = Faker::Internet.url
    delete '/api/v1/file/photo', {token: token, url: url}

    #check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['url'], 'not exists'

    #action 2
    delete '/api/v1/file/photo', {token: token}

    #check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['url'], 'can\'t be blank'
  end

  test 'photo delete fail wrong token' do
    #prepare
    token = Faker::Lorem.characters(10)
    url = Faker::Internet.url

    #action 1
    delete '/api/v1/file/photo', {token: token, url: url}

    #check results
    assert_response 401

    #action 2
    delete '/api/v1/file/photo', {url: url}

    #check results
    assert_response 401
  end
end