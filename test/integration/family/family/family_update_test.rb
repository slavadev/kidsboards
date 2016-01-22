require 'test_helper'

class Family::FamilyUpdateTest < ActionDispatch::IntegrationTest

  test 'family update success' do
    # prepare
    token = login

    # action
    name = Faker::Name.name
    url = Faker::Internet.url
    put '/api/v1/family', token: token, name: name, photo_url: url

    # check results
    assert_response 204
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    family = user.family
    assert_equal name, family.name
    assert_equal url, family.photo_url
  end

  test 'family update fail wrong params' do
    # prepare
    token = login

    # action 1
    name = Faker::Lorem.characters(300)
    url = 'fqweeqw'
    put '/api/v1/family', token: token, name: name, photo_url: url

    # check results
    assert_response 422
    json = JSON.parse(response.body)
    assert_includes json['name'], 'is too long (maximum is 50 characters)'
    assert_includes json['photo_url'], 'is a bad uri'

    # action 2
    name = Faker::Lorem.characters(300)
    url = 'ftp://asdasd.ru'
    put '/api/v1/family', token: token, name: name, photo_url: url

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
    url = Faker::Internet.url
    put '/api/v1/family', token: token, name: name, photo_url: url

    # check results
    assert_response 401
  end

  test 'family update fail without token' do
    # action
    name = Faker::Name.name
    url = Faker::Internet.url
    put '/api/v1/family', name: name, photo_url: url

    # check results
    assert_response 401
  end
end
