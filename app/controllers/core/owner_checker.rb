# Owner checker
module Core::OwnerChecker
  include Core::AuthorizationChecker

  # Check that user is the owner
  # @param [Core::Command] command
  def owner?(command)
    rule = get_rule command
    return if rule.blank?
    return unless get_owner_param rule
    token = get_token command
    user = User::User.get_user_by_token_code(token.code, token.token_type)
    model = command.model_to_validate
    fail Core::Errors::ForbiddenError if model.where(user_id: user.id).first.nil?
  end

  # Get owner param
  # @param [Array] rule
  # @return [Boolean]
  def get_owner_param(rule)
    rule[0]['owner']
  end
end
