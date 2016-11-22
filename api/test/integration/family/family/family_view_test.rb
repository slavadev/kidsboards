require 'test_helper'

class Family::FamilyViewTest < ActionDispatch::IntegrationTest
  test 'family view success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put '/v1/family', params: { token: token, name: name, photo_url: photo_url }
    adults = []
    children = []
    3.times do
      adult_name = Faker::Name.name
      adult_photo_url = Faker::Internet.url
      adult = { 'name' => adult_name, 'photo_url' => adult_photo_url }
      post '/v1/family/adult', params: { token: token, name: adult_name, photo_url: adult_photo_url }
      json = JSON.parse(response.body)
      adult['id'] = json['id']
      adults.push adult

      child_name = Faker::Name.name
      child_photo_url = Faker::Internet.url
      child = { 'name' => child_name, 'photo_url' => child_photo_url }
      post '/v1/family/child', params: { token: token, name: child_name, photo_url: child_photo_url }
      json = JSON.parse(response.body)
      child['id'] = json['id']
      children.push child
    end
    # delete some adults and children
    delete "/v1/family/adult/#{adults[2]['id']}", params: { token: token }
    delete "/v1/family/child/#{children[2]['id']}", params: { token: token }

    # action
    get '/v1/family', params: { token: token }

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal name, json['name']
    assert_equal photo_url, json['photo_url']
    response_adults = json['adults']
    response_children = json['children']
    [0, 1].each do |i|
      assert_equal adults[i], response_adults[i]
      assert_equal children[i], response_children[i]
    end
  end

  test 'family view fail wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)

    # action
    get '/v1/family', params: { token: token }

    # check results
    assert_response 401
  end

  test 'family view fail without token' do
    # action
    get '/v1/family'

    # check results
    assert_response 401
  end
end
