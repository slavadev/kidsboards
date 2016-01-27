require 'test_helper'

class File::PhotoIndexTest < ActionDispatch::IntegrationTest
  test 'photo index success' do
    # prepare
    token = login
    urls = []
    ids = []
    file = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')

    post '/api/v1/file/photo', token: token, file: file
    json = JSON.parse(response.body)
    ids.push(json['id'])
    urls.push(json['url'])

    post '/api/v1/file/photo', token: token, file: file
    json = JSON.parse(response.body)
    ids.push(json['id'])
    urls.push(json['url'])

    post '/api/v1/file/photo', token: token, file: file
    json = JSON.parse(response.body)
    ids.push(json['id'])
    urls.push(json['url'])

    # action
    get '/api/v1/file/photo', token: token
    json = JSON.parse(response.body)
    photo_ids = json['photos'].map{ |x| x['id'] }
    photo_urls = json['photos'].map{ |x| x['url'] }

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
    get '/api/v1/file/photo', token: token
    json = JSON.parse(response.body)
    photo_ids = json['photos'].map{ |x| x['id'] }
    photo_urls = json['photos'].map{ |x| x['url'] }

    # check results
    assert_equal [], photo_ids
    assert_equal [], photo_urls
  end

  test 'photo index fail wrong token' do
    # prepare
    token = Faker::Lorem.characters(10)

    # action 1
    get '/api/v1/file/photo', token: token

    # check results
    assert_response 401

    # action 2
    get '/api/v1/file/photo'

    # check results
    assert_response 401
  end
end
