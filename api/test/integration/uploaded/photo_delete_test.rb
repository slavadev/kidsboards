require 'test_helper'

class Uploaded::PhotoDeleteTest < ActionDispatch::IntegrationTest
  test 'photo delete success' do
    # prepare
    token = login

    file = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    post '/v1/uploaded/photo', token: token, file: file
    json = JSON.parse(response.body)
    id = json['id']

    # action
    delete "/v1/uploaded/photo/#{id}", token: token

    # check results
    assert_response 204
    photo = Uploaded::Photo.where(id: id).first
    assert_not_equal nil, photo.deleted_at
  end

  test 'photo delete wrong user' do
    # prepare
    token = login

    file = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    post '/v1/uploaded/photo', token: token, file: file
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    delete "/v1/uploaded/photo/#{id}", token: token

    # check results
    assert_response 403
  end

  test 'photo delete wrong params' do
    # prepare
    token = login

    # action 1
    id = Faker::Number.number(9)
    delete "/v1/uploaded/photo/#{id}", token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'

    # action 2
    delete '/v1/uploaded/photo', token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'photo delete fail wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action 1
    delete "/v1/uploaded/photo/#{id}", token: token

    # check results
    assert_response 401

    # action 2
    delete "/v1/uploaded/photo/#{id}"

    # check results
    assert_response 401
  end
end
