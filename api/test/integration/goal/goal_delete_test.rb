require 'test_helper'

class Family::GoalDeleteTest < ActionDispatch::IntegrationTest
  test 'goal delete success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", token: token, name: name, photo_url: photo_url, target: target
    json = JSON.parse(response.body)
    id = json['id']

    # action
    delete "/v1/goal/#{id}", token: token

    # check results
    assert_response 204
    goal = Goal::Goal.where(id: id).first
    assert_not_nil goal
    assert_not_nil goal.deleted_at
  end

  test 'goal delete with wrong params' do
    # prepare
    token = login

    # action 1
    id = Faker::Number.number(9)
    delete "/v1/goal/#{id}", token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'

    # action 2
    delete '/v1/goal', token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'goal delete wrong user' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", token: token, name: name, photo_url: photo_url, target: target
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    delete "/v1/goal/#{id}", token: token

    # check results
    assert_response 403
  end

  test 'goal delete wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    delete "/v1/goal/#{id}", token: token

    # check results
    assert_response 401
  end

  test 'goal delete without token' do
    # prepare
    id = Faker::Number.number(9)

    # action
    delete "/v1/goal/#{id}"

    # check results
    assert_response 401
  end
end
