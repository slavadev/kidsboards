ENV['RAILS_ENV'] = 'test'
ENV['CODECLIMATE_REPO_TOKEN'] = '497eb1d6581d560277807f87b4a41f795558faa623dd7cf509dc8c991909090a'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.configure do |config|
  config.path_prefix = 'api'
  config.git_dir = '..'
end
CodeClimate::TestReporter.start if ARGV.include? 'coverage'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/pride'

# Common function for tests
class ActiveSupport::TestCase
  # Code that needs to be executed before test suite start
  def self.prepare
  end
  prepare

  # Code that need to be executed before each test
  def setup
    DatabaseCleaner.start
    FileUtils.rm_rf('public/images')
  end

  # Code that need to be executed after each test
  def teardown
    DatabaseCleaner.clean
    FileUtils.rm_rf('public/images')
  end

  # Quick login and returns token code
  def login
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/api/v1/user/register', params
    post '/api/v1/user/login', params
    json = JSON.parse(response.body)
    json['token']
  end

  # Assert one array to include in other
  def assert_includes_like(what, where)
  end
end
