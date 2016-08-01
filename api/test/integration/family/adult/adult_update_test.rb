require 'test_helper'

class Family::AdultUpdateTest < ActionDispatch::IntegrationTest
  test 'adult update success' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/adult', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put "/v1/family/adult/#{id}", token: token, name: name, photo_url: photo_url

    # check results
    assert_response 204
    adult = Family::Adult.where(id: id).first
    assert_equal name, adult.name
    assert_equal photo_url, adult.photo_url
  end

  test 'adult update only one param success' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/adult', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']

    # action 1
    name = Faker::Name.name
    put "/v1/family/adult/#{id}", token: token, name: name

    # check results
    assert_response 204
    adult = Family::Adult.where(id: id).first
    assert_equal name, adult.name
    assert_equal photo_url, adult.photo_url

    # action 2
    photo_url = Faker::Internet.url
    put "/v1/family/adult/#{id}", token: token, photo_url: photo_url

    # check results
    assert_response 204
    adult = Family::Adult.where(id: id).first
    assert_equal name, adult.name
    assert_equal photo_url, adult.photo_url
  end

  test 'adult update wrong params' do
    token = login

    # action 1
    id = Faker::Number.number(9)
    name = Faker::Lorem.characters(300)
    photo_url = 'fqweeqw'
    put "/v1/family/adult/#{id}", token: token, name: name, photo_url: photo_url

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'is a bad uri'

    # action 2
    put '/v1/family/adult', token: token

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
    assert_includes json['id'], 'can\'t be blank'
  end

  test 'adult update deleted' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/adult', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    delete "/v1/family/adult/#{id}", token: token
    put "/v1/family/adult/#{id}", token: token, name: name, photo_url: photo_url

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['id'], 'does not exist'
  end

  test 'adult update wrong user' do
    token = login
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    post '/v1/family/adult', token: token, name: name, photo_url: photo_url
    json = JSON.parse(response.body)
    id = json['id']
    token = login

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put "/v1/family/adult/#{id}", token: token, name: name, photo_url: photo_url

    # check results
    assert_response 403
  end

  test 'adult update wrong token' do
    token = Faker::Lorem.characters(10)
    id = Faker::Number.number(9)

    # action
    put "/v1/family/adult/#{id}", token: token

    # check results
    assert_response 401
  end

  test 'adult update without token' do
    id = Faker::Number.number(9)

    # action
    put "/v1/family/adult/#{id}"

    # check results
    assert_response 401
  end
end
