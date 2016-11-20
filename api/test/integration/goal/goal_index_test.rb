require 'test_helper'

class Family::GoalIndexTest < ActionDispatch::IntegrationTest
  test 'goal index success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    child_id = json['id']

    goals = []
    3.times do
      name = Faker::Name.name
      photo_url = Faker::Internet.url
      target = Faker::Number.number(2).to_i
      post "/v1/family/child/#{child_id}/goal", params: { token: token, name: name, photo_url: photo_url,  target: target }
      json = JSON.parse(response.body)
      id = json['id']
      goal = { id: id, name: name, photo_url: photo_url, target: target }
      goals.push goal
    end

    delete "/v1/goal/#{goals[2][:id]}", params: { token: token }

    # action
    get "/v1/family/child/#{child_id}/goal", params: { token: token }

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 2, json['goals'].count
    (0..1).each do |i|
      assert_equal goals[i][:id], json['goals'][i]['id']
      assert_equal goals[i][:photo_url], json['goals'][i]['photo_url']
      assert_equal goals[i][:name], json['goals'][i]['name']
      assert_equal goals[i][:target], json['goals'][i]['target']
      assert_equal 0, json['goals'][i]['current']
    end
  end

  test 'goal index without goals success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    child_id = json['id']

    # action
    get "/v1/family/child/#{child_id}/goal", params: { token: token }

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 0, json['goals'].count
  end

  test 'goal index with filters success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    child_id = json['id']
    post '/v1/family/adult', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    adult_id = json['id']

    goals = []
    3.times do
      name = Faker::Name.name
      photo_url = Faker::Internet.url
      target = Faker::Number.number(2).to_i
      post "/v1/family/child/#{child_id}/goal", params: { token: token, name: name, photo_url: photo_url,  target: target }
      json = JSON.parse(response.body)
      id = json['id']
      goal = { id: id, name: name, photo_url: photo_url, target: target }
      goals.push goal
    end

    diff = goals[2][:target]
    patch "/v1/goal/#{goals[2][:id]}/points", params: { token: token, adult_id: adult_id, diff: diff }

    # action 1
    get "/v1/family/child/#{child_id}/goal", params: { token: token }

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 3, json['goals'].count

    # action 2
    get "/v1/family/child/#{child_id}/goal", params: { token: token, completed: false }

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 2, json['goals'].count
    (0..1).each do |i|
      assert_equal goals[i][:id], json['goals'][i]['id']
      assert_equal 0, json['goals'][i]['current']
    end

    # action 2
    get "/v1/family/child/#{child_id}/goal", params: { token: token, completed: true }

    # check results
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json['goals'].count
    assert_equal goals[2][:id], json['goals'][0]['id']
    assert_equal goals[2][:target], json['goals'][0]['current']
  end

  test 'goal index wrong params' do
    # prepare
    token = login
    child_id = Faker::Number.number(9)

    # action 1
    get "/v1/family/child/#{child_id}/goal", params: { token: token }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'

    # action 2
    get '/v1/family/child/goal', params: { token: token }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'goal index wrong user' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    child_id = json['id']

    # action
    token = login
    get "/v1/family/child/#{child_id}/goal", params: { token: token }

    # check results
    assert_response 403
  end

  test 'goal index wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)
    child_id = Faker::Number.number(9)

    # action 1
    get "/v1/family/child/#{child_id}/goal", params: { token: token }

    # check results
    assert_response 401
  end

  test 'goal index without token' do
    # prepare
    child_id = Faker::Number.number(9)

    # action 1
    get "/v1/family/child/#{child_id}/goal"

    # check results
    assert_response 401
  end
end
