require 'test_helper'

class Family::FamilyViewTest < ActionDispatch::IntegrationTest

  test 'family view success' do
    # prepare
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put '/api/v1/family', token: token, name: name, photo_url: photo_url
    adults = []
    children = []
    3.times do
      adult_name = Faker::Name.name
      adult_photo_url = Faker::Internet.url
      adult = {'name' => adult_name, 'photo_url' => adult_photo_url}
      post '/api/v1/family/adult', token: token, name: adult_name, photo_url: adult_photo_url
      json = JSON.parse(response.body)
      adult['id'] = json['id']
      adults.push adult

      child_name = Faker::Name.name
      child_photo_url = Faker::Internet.url
      child = {'name' => child_name, 'photo_url' => child_photo_url}
      post '/api/v1/family/child', token: token, name: child_name, photo_url: child_photo_url
      json = JSON.parse(response.body)
      child['id'] = json['id']
      children.push child
    end
    # delete some adults and children
    delete "/api/v1/family/adult/#{adults[2]['id']}", token: token
    delete "/api/v1/family/child/#{children[2]['id']}", token: token

    # action
    get '/api/v1/family', token: token

    # check results
    assert_response 200
    json = JSON.parse(response.body)
    assert_equal name, json['name']
    assert_equal photo_url, json['photo_url']
    response_adults = json['adults']
    response_children = json['children']
    [0,1].each do |i|
      assert_equal adults[i]['id'], response_adults[i]['id']
      assert_equal adults[i]['name'], response_adults[i]['name']
      assert_equal adults[i]['photo_url'], response_adults[i]['photo_url']
      assert_equal children[i]['id'], response_children[i]['id']
      assert_equal children[i]['name'], response_children[i]['name']
      assert_equal children[i]['photo_url'], response_children[i]['photo_url']
    end
  end


  test 'family view fail wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)

    # action
    get '/api/v1/family', token: token

    # check results
    assert_response 401
  end

  test 'family view fail without token' do
    # action
    get '/api/v1/family'

    # check results
    assert_response 401
  end
end
