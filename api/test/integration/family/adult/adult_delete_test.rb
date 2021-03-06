require 'test_helper'

class Family::AdultDeleteTest < ActionDispatch::IntegrationTest
  test 'adult delete success' do
    token = login
    name = Faker::Name.name
    url = Faker::Internet.url
    post '/v1/family/adult', params: { token: token, name: name, photo_url: url }
    json = JSON.parse(response.body)
    id = json['id']

    # action
    delete "/v1/family/adult/#{id}", params: { token: token }

    # check results
    assert_response 204
    adult = Family::Adult.where(id: id).first
    assert_not_nil adult.deleted_at
  end

  test 'adult delete wrong params' do
    token = login

    # action 1
    id = Faker::Number.number(9)
    delete "/v1/family/adult/#{id}", params: { token: token }

    # check results
    assert_response 404

    # action 2
    delete '/v1/family/adult', params: { token: token }

    # check results
    assert_response 404
  end

  test 'adult delete wrong user' do
    token = login
    name = Faker::Name.name
    url = Faker::Internet.url
    post '/v1/family/adult', params: { token: token, name: name, photo_url: url }
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    delete "/v1/family/adult/#{id}", params: { token: token }

    # check results
    assert_response 403
  end

  test 'adult delete wrong token' do
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    delete "/v1/family/adult/#{id}", params: { token: token }

    # check results
    assert_response 401
  end

  test 'adult delete without token' do
    id = Faker::Number.number(9)

    # action
    delete "/v1/family/adult/#{id}"

    # check results
    assert_response 401
  end
end
