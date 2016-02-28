require 'test_helper'

class Family::GoalUpdateTest < ActionDispatch::IntegrationTest
  test 'goal update success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/api/v1/family/child/#{id}/goal", token: token, name: name, photo_url: photo_url, target: target
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    target = Faker::Number.number(2).to_i
    put "/api/v1/goal/#{id}", token: token, name: name, photo_url: photo_url, target: target

    # check results
    assert_response 204
    goal = Goal::Goal.where(id: id).first
    assert_not_nil goal
    assert_equal name, goal.name
    assert_equal photo_url, goal.photo_url
    assert_equal target, goal.target
    assert_equal 0, goal.current
  end

  test 'goal update with only one param success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/api/v1/family/child/#{id}/goal", token: token, name: name, photo_url: photo_url, target: target
    json = JSON.parse(response.body)
    id = json['id']

    # action 1
    name = Faker::Name.name
    put "/api/v1/goal/#{id}", token: token, name: name

    # check results
    assert_response 204
    goal = Goal::Goal.where(id: id).first
    assert_not_nil goal
    assert_equal name, goal.name
    assert_equal photo_url, goal.photo_url
    assert_equal target, goal.target
    assert_equal 0, goal.current

    # action 2
    photo_url = Faker::Internet.url
    put "/api/v1/goal/#{id}", token: token, photo_url: photo_url

    # check results
    assert_response 204
    goal = Goal::Goal.where(id: id).first
    assert_not_nil goal
    assert_equal name, goal.name
    assert_equal photo_url, goal.photo_url
    assert_equal target, goal.target
    assert_equal 0, goal.current

    # action 3
    target = Faker::Number.number(2).to_i
    put "/api/v1/goal/#{id}", token: token, target: target

    # check results
    assert_response 204
    goal = Goal::Goal.where(id: id).first
    assert_not_nil goal
    assert_equal name, goal.name
    assert_equal photo_url, goal.photo_url
    assert_equal target, goal.target
    assert_equal 0, goal.current
  end

  test 'goal update with wrong params' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/api/v1/family/child/#{id}/goal", token: token, name: name, photo_url: photo_url, target: target
    json = JSON.parse(response.body)
    id = json['id']

    # action 1
    name = Faker::Lorem.characters(300)
    photo_url = 'fqweeqw'
    target = 1000
    put "/api/v1/goal/#{id}", token: token, name: name, photo_url: photo_url, target: target

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'is a bad uri'
    assert_includes json['target'], 'must be less than 1000'

    # action 2
    id = Faker::Number.number(9)
    put "/api/v1/goal/#{id}", token: token, name: name, photo_url: photo_url, target: target

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'

    # action 2
    put '/api/v1/goal', token: token, name: name, photo_url: photo_url, target: target

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'goal update deleted' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/api/v1/family/child/#{id}/goal", token: token, name: name, photo_url: photo_url, target: target
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    target = Faker::Number.number(2).to_i
    delete "/api/v1/goal/#{id}", token: token
    put "/api/v1/goal/#{id}", token: token, name: name, photo_url: photo_url, target: target

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
  end

  test 'goal update wrong user' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/api/v1/family/child', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/api/v1/family/child/#{id}/goal", token: token, name: name, photo_url: photo_url, target: target
    json = JSON.parse(response.body)
    id = json['id']

    # action
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    target = Faker::Number.number(2).to_i + 1 # + 1 because of the bug with number generation in Faker
    put "/api/v1/goal/#{id}", token: token, name: name, photo_url: photo_url, target: target

    # check results
    assert_response 403
  end

  test 'goal update wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    put "/api/v1/goal/#{id}", token: token

    # check results
    assert_response 401
  end

  test 'goal update without token' do
    # prepare
    id = Faker::Number.number(9)

    # action
    put "/api/v1/goal/#{id}"

    # check results
    assert_response 401
  end
end
