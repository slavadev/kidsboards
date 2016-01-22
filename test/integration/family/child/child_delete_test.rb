require 'test_helper'

class Family::ChildDeleteTest < ActionDispatch::IntegrationTest

  test 'child delete success' do
    token = login
    name = Faker::Name.name
    url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: url
    json = JSON.parse(response.body)
    id = json['id']

    # action
    delete "/api/v1/family/child/#{id}", token: token

    # check results
    assert_response 204
    child = Family::Child.where(id: id).first
    assert_not_nil child.deleted_at
  end

  test 'child delete wrong params' do
    token = login

    # action 1
    id = Faker::Number.number(9)
    delete "/api/v1/family/child/#{id}", token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'

    # action 2
    delete '/api/v1/family/child', token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'child delete wrong user' do
    token = login
    name = Faker::Name.name
    url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: url
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    delete "/api/v1/family/child/#{id}", token: token

    # check results
    assert_response 403
  end

  test 'child delete wrong token' do
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    delete "/api/v1/family/child/#{id}", token: token

    # check results
    assert_response 401
  end

  test 'child delete without token' do
    id = Faker::Number.number(9)

    # action
    delete "/api/v1/family/child/#{id}"

    # check results
    assert_response 401
  end
end
