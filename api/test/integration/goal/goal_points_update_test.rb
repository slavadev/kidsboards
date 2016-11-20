require 'test_helper'

class Family::GoalPointsUpdateTest < ActionDispatch::IntegrationTest
  test 'goal points update success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/adult', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    adult_id = json['id']
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }
    json = JSON.parse(response.body)
    id = json['id']

    # action 1
    diff = Faker::Number.number(1).to_i + 1
    diff0 = diff
    patch "/v1/goal/#{id}/points", params: { token: token, adult_id: adult_id, diff: diff }

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal target, json['target']
    assert_equal diff, json['current']
    action = Goal::Action.where(goal_id: id, adult_id: adult_id, diff: diff).first
    assert_not_nil action
    assert_in_delta action.created_at, DateTime.now.utc, 1

    # action 2
    diff = - Faker::Number.number(1).to_i - diff
    patch "/v1/goal/#{id}/points", params: { token: token, adult_id: adult_id, diff: diff }

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal target, json['target']
    assert_equal 0, json['current']
    action = Goal::Action.where(goal_id: id, adult_id: adult_id, diff: -diff0).first
    assert_not_nil action
    assert_in_delta action.created_at, DateTime.now.utc, 1

    # action 3
    diff = Faker::Number.number(1).to_i + target
    patch "/v1/goal/#{id}/points", params: { token: token, adult_id: adult_id, diff: diff }

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal target, json['target']
    assert_equal target, json['current']
    action = Goal::Action.where(goal_id: id, adult_id: adult_id, diff: target).first
    assert_not_nil action
    assert_in_delta action.created_at, DateTime.now.utc, 1
  end

  test 'goal points update with wrong params' do
    # prepare
    token = login
    adult_id = Faker::Number.number(9)
    id = Faker::Number.number(9)
    diff = Faker::Number.decimal(2)

    # action 1
    patch "/v1/goal/#{id}/points", params: { token: token, adult_id: adult_id, diff: diff }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['adult_id'], 'does not exist'
    assert_includes json['diff'], 'must be an integer'

    # action 2
    patch '/v1/goal/points', params: { token: token }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'can\'t be blank'
    assert_includes json['adult_id'], 'can\'t be blank'
    assert_includes json['diff'], 'is not a number'
  end

  test 'goal points update while the goal is deleted' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/adult', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    adult_id = json['id']
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }
    json = JSON.parse(response.body)
    id = json['id']
    diff = Faker::Number.number(1).to_i

    # action 1
    delete "/v1/goal/#{id}", params: { token: token }
    patch "/v1/goal/#{id}/points", params: { token: token, adult_id: adult_id, diff: diff }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
  end

  test 'goal points update with wrong user' do
    # prepare
    token1 = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/adult', params: { token: token1, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    adult_id = json['id']
    token = login
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }
    json = JSON.parse(response.body)
    id = json['id']
    diff = Faker::Number.number(1).to_i

    # action 1
    patch "/v1/goal/#{id}/points", params: { token: token, adult_id: adult_id, diff: diff }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['adult_id'], 'does not exist'

    # action 2
    patch "/v1/goal/#{id}/points", params: { token: token1, adult_id: adult_id, diff: diff }

    # check results
    assert_response 403
  end

  test 'goal points update with wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    patch "/v1/goal/#{id}/points", params: { token: token }

    # check results
    assert_response 401
  end

  test 'goal points update without token' do
    # prepare
    id = Faker::Number.number(9)

    # action
    patch "/v1/goal/#{id}/points"

    # check results
    assert_response 401
  end
end
