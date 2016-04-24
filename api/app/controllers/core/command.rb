# Contains common methods for commands
class Core::Command
  include ActiveModel::Validations

  attr_accessor :token

  # Fills a command with attributes
  # @param [Hash] attributes
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

  # Gets the model to validate
  # @return [Class]
  # @raise Core::Errors::NoModelToValidateError
  def model_to_validate
    raise Core::Errors::NoModelToValidateError
  end
end
