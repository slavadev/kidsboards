source 'https://rubygems.org'

gem 'mongo'
gem 'rails', '4.2.4'
gem 'mongoid', '~> 5.0.0'

# documentation
gem 'yard'

# server
gem 'passenger'

# files
gem 'mongoid-paperclip', require: 'mongoid_paperclip'

gem 'minitest-rails'
group :test do
  gem 'minitest-focus'
  gem 'faker'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: nil
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
