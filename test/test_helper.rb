ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"

class ActiveSupport::TestCase

  def self.prepare
    # Add code that needs to be executed before test suite start
  end
  prepare

  def setup
    # Add code that need to be executed before each test
    DatabaseCleaner.start
    FileUtils.rm_rf('public/images')
  end

  def teardown
    # Add code that need to be executed after each test
    DatabaseCleaner.clean
    FileUtils.rm_rf('public/images')
  end

  def login
    email = Faker::Internet.free_email
    password = Faker::Internet.password
    params = {email: email, password: password}
    post '/api/v1//user/register', params
    post '/api/v1//user/login', params
    json = JSON.parse(response.body)
    json['token']
  end
end
