# Contains common methods for commands
class Core::Command
  include ActiveModel::Validations

  attr_accessor :token

  # Fills a command with attributes
  # @param [Hash] attributes
  # @raise Core::Errors::ValidationError
  def initialize(attributes = {})
    attributes.each do |name, value|
      if methods.include? "#{name}=".to_sym
        method("#{name}=".to_sym).call(value)
      end
    end
  end

  # Runs command
  def execute
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: :login }
  end

  # Checks that command can be executed by the user
  def check_authorization
    User::Service::AuthorizationService.get.get_token_by_command self
  end

  # Checks that all params are correct
  def check_validation
    raise(Core::Errors::ValidationError, self) if self.invalid?
  end
end
