# Owner checker
module Core::OwnerChecker
  include Core::AuthorizationChecker

  # Check that user is the owner
  # @param [Core::Command] command
  def owner?(command)
    rules = Rails.configuration.authorization_rules
    return if rules.select { |rule| rule['action'] == command.class.name }.blank?
    return unless get_owner_param rules, command
    token = get_token command
    user = User::User.get_user_by_token_code(token.code, token.token_type)
    model = command.model_to_validate
    raise Core::Errors::ForbiddenError if model.where(user_id: user.id).first.nil?
  end

  # Get owner param
  # @param [Array] rules
  # @param [Core::Command] command
  # @return [Boolean]
  def get_owner_param(rules, command)
    if rules.select { |rule| rule['action'] == command.class.name }[0]['owner']
      return true
    end
    false
  end

end
