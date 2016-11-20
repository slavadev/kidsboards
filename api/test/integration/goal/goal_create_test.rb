require 'test_helper'

class Family::GoalCreateTest < ActionDispatch::IntegrationTest
  test 'goal create success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    id = json['id']
    goal = Goal::Goal.where(id: id).first
    assert_not_nil goal
    assert_equal name, goal.name
    assert_equal photo_url, goal.photo_url
    assert_equal target, goal.target
    assert_equal 0, goal.current
  end

  test 'goal create without photo success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, target: target }

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    id = json['id']
    goal = Goal::Goal.where(id: id).first
    assert_not_nil goal
    assert_equal name, goal.name
    assert_equal nil, goal.photo_url
    assert_equal target, goal.target
    assert_equal 0, goal.current
  end

  test 'goal create wrong params' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action 1
    post "/v1/family/child/#{id}/goal", params: { token: token }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['name'], 'can\'t be blank'
    assert_includes json['target'], 'is not a number'

    # action 2
    name = Faker::Lorem.characters(300)
    photo_url = 'fqweeqw'
    target = 1000
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'is a bad uri'
    assert_includes json['target'], 'must be less than 1000'

    # action 3
    target = -1
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['target'], 'must be greater than 0'

    # action 4
    target = 2.5
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['target'], 'must be an integer'

    # action 5
    id = Faker::Number.number(9)
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'

    # action 6
    post '/v1/family/child/goal', params: { token: token, name: name, photo_url: photo_url, target: target }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'goal create wrong user' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    target = Faker::Number.number(2).to_i
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']

    # action
    token = login
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }

    # check results
    assert_response 403
  end

  test 'goal create wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    post "/v1/family/child/#{id}/goal", params: { token: token }

    # check results
    assert_response 401
  end

  # focus
  test 'goal create without token' do
    # prepare
    id = Faker::Number.number(9)

    # action
    post "/v1/family/child/#{id}/goal"

    # check results
    assert_response 401
  end
end
