require 'test_helper'

class Uploaded::PhotoIndexTest < ActionDispatch::IntegrationTest
  test 'photo index success' do
    # prepare
    token = login
    urls = []
    ids = []
    file = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')

    post '/v1/uploaded/photo', params: { token: token, file: file }
    json = JSON.parse(response.body)
    ids.push(json['id'])
    urls.push(json['url'])

    post '/v1/uploaded/photo', params: { token: token, file: file }
    json = JSON.parse(response.body)
    ids.push(json['id'])
    urls.push(json['url'])

    post '/v1/uploaded/photo', params: { token: token, file: file }
    json = JSON.parse(response.body)
    ids.push(json['id'])
    urls.push(json['url'])

    # action
    get '/v1/uploaded/photo', params: { token: token }
    json = JSON.parse(response.body)
    assert_response :success
    photo_ids = json.map { |x| x['id'] }
    photo_urls = json.map { |x| x['url'] }

    # check results
    ids.each do |id|
      assert_includes photo_ids, id
    end
    urls.each do |url|
      assert_includes photo_urls, url
    end
  end

  test 'photo index success without photos' do
    # prepare
    token = login

    # action
    get '/v1/uploaded/photo', params: { token: token }
    assert_response :success
    json = JSON.parse(response.body)
    photo_ids = json.map { |x| x['id'] }
    photo_urls = json.map { |x| x['url'] }

    # check results
    assert_equal [], photo_ids
    assert_equal [], photo_urls
  end

  test 'photo index fail wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)

    # action 1
    get '/v1/uploaded/photo', params: { token: token }

    # check results
    assert_response 401

    # action 2
    get '/v1/uploaded/photo'

    # check results
    assert_response 401
  end
end
