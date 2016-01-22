# Common methods for commands
class Core::Command
  include ActiveModel::Validations

  attr_accessor :token

  # Fulfill input with attributes
  # @param [Hash] attributes
  def initialize(attributes = {})
    attributes.each do |name, value|
      if methods.include? "#{name}=".to_sym
        method("#{name}=".to_sym).call(value)
      end
    end
  end

  # Run command
  def execute
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    raise Core::Errors::NoModelToValidateError
  end
end
