require File.expand_path('../boot', __FILE__)

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'rake/testtask'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'minitest/rails/railtie'

Bundler.require(*Rails.groups)

module Thatsaboy
  class Application < Rails::Application
    # Faker
    Faker::Config.locale = :ru if Rails.env == 'test'

    # Mute mongo
    Mongoid.logger.level = Logger::INFO
    Mongoid.raise_not_found_error = false
    Mongo::Logger.logger.level = Logger::INFO

    # Add authorization rules
    config.authorization_rules = config_for('authorization_rules')
  end
end
