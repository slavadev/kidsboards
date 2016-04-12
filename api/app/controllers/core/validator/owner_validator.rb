# Checks that the model owner is current user
class Core::Validator::OwnerValidator < ActiveModel::EachValidator
  include Core::Authorization
  # Validation function
  # @param [Object] record
  # @param [String] attribute
  # @param [Object] _value
  # @raise Core::Errors::ForbiddenError
  def validate_each(record, attribute, _value)
    rule = get_rule record
    return if rule.blank?
    token = get_token record
    user = User::User.get_user_by_token_code(token.code, token.token_type)
    item = options[:with].call(record)
    return unless item
    unless item.user == user
      fail Core::Errors::ForbiddenError
    end
  end
end
