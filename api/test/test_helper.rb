ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

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
    FileUtils.rm_rf('public/photos')
  end

  # Code that need to be executed after each test
  def teardown
    DatabaseCleaner.clean
    FileUtils.rm_rf('public/photos')
  end

  # Quick login and returns token code
  # @return [String]
  def login
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = { email: email, password: password }
    post '/v1/user/register', params: params
    post '/v1/user/login', params: params
    json = JSON.parse(response.body)
    json['token']
  end

  # Gets user by given token
  # @param [String] code
  # @return [User::User]
  def get_user_by_token(code)
    User::Token.where(code: code, token_type: User::Token::TYPE_LOGIN).first.user
  end
end

class ActionMailer::MessageDelivery
  def deliver_later
    deliver_now
  end
end
