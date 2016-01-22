require 'test_helper'

class Family::ChildUpdateTest < ActionDispatch::IntegrationTest

  test 'child update success' do
    token = login
    name = Faker::Name.name
    url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: url
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    url = Faker::Internet.url
    put "/api/v1/family/child/#{id}", token: token, name: name, photo_url: url

    # check results
    assert_response 204
    child = Family::Child.where(id: id).first
    assert_equal name, child.name
    assert_equal url, child.photo_url
  end

  test 'child update wrong params' do
    token = login

    # action 1
    id = Faker::Number.number(9)
    name = Faker::Lorem.characters(300)
    url = 'fqweeqw'
    put "/api/v1/family/child/#{id}", token: token, name: name, photo_url: url

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'is a bad uri'


    # action 2
    put '/api/v1/family/child', token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'child update wrong user' do
    token = login
    name = Faker::Name.name
    url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: url
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    name = Faker::Name.name
    url = Faker::Internet.url
    put "/api/v1/family/child/#{id}", token: token, name: name, photo_url: url

    # check results
    assert_response 403
  end

  test 'child update wrong token' do
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    put "/api/v1/family/child/#{id}", token: token

    # check results
    assert_response 401
  end

  test 'child update without token' do
    id = Faker::Number.number(9)

    # action
    put "/api/v1/family/child/#{id}"

    # check results
    assert_response 401
  end
end
