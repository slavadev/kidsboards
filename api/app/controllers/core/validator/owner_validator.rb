# Checks that the model owner is current user
class Core::Validator::OwnerValidator < ActiveModel::EachValidator
  # Sets all variables
  # @param [Object] params
  # @see User::AuthorizationService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
  end

  # Validation function
  # @param [Object] record
  # @param [String] _attribute
  # @param [Object] _value
  # @raise Core::Errors::ForbiddenError
  def validate_each(record, _attribute, _value)
    rule = @authorization_service.get_rule_by_command record
    return if rule.blank?
    token = @authorization_service.get_token_by_command record
    user = token.user
    item = options[:with].call(record)
    return unless item
    raise Core::Errors::ForbiddenError unless item.user == user
  end
end
