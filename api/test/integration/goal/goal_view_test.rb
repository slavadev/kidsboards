require 'test_helper'

class Family::GoalViewTest < ActionDispatch::IntegrationTest
  test 'goal view success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }
    json = JSON.parse(response.body)
    id = json['id']

    # action
    get "/v1/goal/#{id}", params: { token: token }

    # check results
    assert_response :success
    goal = JSON.parse(response.body)
    assert_equal name, goal['name']
    assert_equal photo_url, goal['photo_url']
    assert_equal target, goal['target']
    assert_equal 0, goal['current']
    assert_in_delta Time.parse(goal['created_at']).getutc, DateTime.now.utc, 1
    assert_equal [], goal['actions']
  end

  test 'goal view success with actions' do
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
    target = Faker::Number.number(3).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }
    json = JSON.parse(response.body)
    id = json['id']

    actions = []
    3.times do
      diff = Faker::Number.number(1).to_i + 1
      patch "/v1/goal/#{id}/points", params: { token: token, adult_id: adult_id, diff: diff }
      actions.push('adult' => {
                     'id' => adult_id,
                     'name' => name,
                     'photo_url' => photo_url
                   },
                   'diff' => diff)
    end

    # action
    get "/v1/goal/#{id}", params: { token: token }

    # check results
    assert_response :success
    goal = JSON.parse(response.body)
    result_actions = goal['actions']
    (0..2).each do |i|
      assert_equal actions[i]['adult'], result_actions[i]['adult']
      assert_equal actions[i]['diff'], result_actions[i]['diff']
      result_actions[i]['created_at'] = Time.parse(result_actions[i]['created_at']).getutc
    end
    assert_equal true, result_actions[0]['created_at'] < result_actions[1]['created_at']
    assert_equal true, result_actions[1]['created_at'] < result_actions[2]['created_at']
  end

  test 'goal view wrong params' do
    # prepare
    token = login
    id = Faker::Number.number(9)

    # action 1
    get "/v1/goal/#{id}", params: { token: token }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'

    # action 2
    get '/v1/goal', params: { token: token }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'goal view wrong user' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    get "/v1/goal/#{id}", params: { token: token }

    # check results
    assert_response 403
  end

  test 'goal view deleted' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/child', params: { token: token, name: name, photo_url: photo_url }
    json = JSON.parse(response.body)
    id = json['id']
    target = Faker::Number.number(2).to_i
    post "/v1/family/child/#{id}/goal", params: { token: token, name: name, photo_url: photo_url, target: target }
    json = JSON.parse(response.body)
    id = json['id']
    delete "/v1/goal/#{id}", params: { token: token }

    # action
    get "/v1/goal/#{id}", params: { token: token }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
  end

  test 'goal view wrong token' do
    # prepare
    id = Faker::Number.number(9)
    token = Faker::Lorem.characters(10)

    # action
    get "/v1/goal/#{id}", params: { token: token }

    # check results
    assert_response 401
  end

  test 'goal view without token' do
    # prepare
    id = Faker::Number.number(9)

    # action
    get "/v1/goal/#{id}"

    # check results
    assert_response 401
  end
end
