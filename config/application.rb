require File.expand_path('../boot', __FILE__)

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
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
    # Add authorization rules
    config.authorization_rules = config_for('authorization_rules')

    # Some AR warnings
    config.active_record.raise_in_transactional_callbacks = true
  end
end
