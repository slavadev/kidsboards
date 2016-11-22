require 'test_helper'

class Family::ChildUpdateTest < ActionDispatch::IntegrationTest
  test 'child update success' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put "/v1/family/child/#{id}", params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 204
    child = Family::Child.where(id: id).first
    assert_equal name, child.name
    assert_equal photo_url, child.photo_url
  end

  test 'child update only one param success' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action 1
    name = Faker::Name.name
    put "/v1/family/child/#{id}", params: { token: token, name: name }

    # check results
    assert_response 204
    child = Family::Child.where(id: id).first
    assert_equal name, child.name
    assert_equal photo_url, child.photo_url

    # action 2
    photo_url = Faker::Internet.url
    put "/v1/family/child/#{id}", params: { token: token, photo_url: photo_url }

    # check results
    assert_response 204
    child = Family::Child.where(id: id).first
    assert_equal name, child.name
    assert_equal photo_url, child.photo_url
  end

  test 'child update wrong params' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action 1
    name = Faker::Lorem.characters(300)
    photo_url = 'fqweeqw'
    put "/v1/family/child/#{id}", params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'is a bad uri'

    # action 2
    id = Faker::Number.number(9)
    put '/v1/family/child', params: { token: token }

    # check results
    assert_response 404
  end

  test 'child update deleted' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    delete "/v1/family/child/#{id}", params: { token: token }
    put "/v1/family/child/#{id}", params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 404
  end

  test 'child update wrong user' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put "/v1/family/child/#{id}", params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 403
  end

  test 'child update wrong token' do
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    put "/v1/family/child/#{id}", params: { token: token }

    # check results
    assert_response 401
  end

  test 'child update without token' do
    id = Faker::Number.number(9)

    # action
    put "/v1/family/child/#{id}"

    # check results
    assert_response 401
  end
end
