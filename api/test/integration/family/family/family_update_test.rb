require 'test_helper'

class Family::FamilyUpdateTest < ActionDispatch::IntegrationTest
  test 'family update success' do
    # prepare
    token = login

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put '/v1/family', params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 204
    user = User::AuthorizationService.new.get_user_by_token_code(token)
    family = user.family
    assert_equal name, family.name
    assert_equal photo_url, family.photo_url
  end

  test 'family update only photo success' do
    # prepare
    token = login

    # action
    photo_url = Faker::Internet.url
    put '/v1/family', params: { token: token, photo_url: photo_url }

    # check results
    assert_response 204
    user = User::AuthorizationService.new.get_user_by_token_code(token)
    family = user.family
    assert_equal '', family.name
    assert_equal photo_url, family.photo_url
  end

  test 'family update only name success' do
    # prepare
    token = login

    # action
    name = Faker::Name.name
    put '/v1/family', params: { token: token, name: name }

    # check results
    assert_response 204
    user = User::AuthorizationService.new.get_user_by_token_code(token)
    family = user.family
    assert_equal name, family.name
    assert_equal nil, family.photo_url
  end

  test 'family update fail wrong params' do
    # prepare
    token = login

    # action 1
    name = Faker::Lorem.characters(300)
    photo_url = 'fqweeqw'
    put '/v1/family', params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'is a bad uri'

    # action 2
    name = Faker::Lorem.characters(300)
    photo_url = 'ftp://asdasd.ru'
    put '/v1/family', params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'has wrong protocol (use http or https)'
  end

  test 'family update fail wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)

    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put '/v1/family', params: { token: token, name: name, photo_url: photo_url }

    # check results
    assert_response 401
  end

  test 'family update fail without token' do
    # action
    name = Faker::Name.name
    photo_url = Faker::Internet.url
    put '/v1/family', params: { name: name, photo_url: photo_url }

    # check results
    assert_response 401
  end
end
