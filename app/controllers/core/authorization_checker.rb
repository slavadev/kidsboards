# Default authorization checker
module Core::AuthorizationChecker
  # Check for authorization
  # @param [Core::Command] command
  def authorized?(command)
    get_token command
  end

  # Get the token
  # @param [Core::Command] command
  # @return [User::Token] token
  def get_token(command)
    rule = get_rule(command)
    return if rule.blank?
    token = params['token']
    fail Core::Errors::UnauthorizedError if token.nil?
    type = get_type(rule)
    token = User::Token.where(code: token, token_type: type).first
    fail Core::Errors::UnauthorizedError if token.nil?
    token
  end

  # Get the rule for the command
  # @param [Core::Command] command
  def get_rule(command)
    rules = Rails.configuration.authorization_rules
    rules.select { |rule| rule['action'] == command.class.name }
  end

  # Get type of the token
  # @param [Hash] rule
  # @return [Integer]
  def get_type(rule)
    case rule[0]['token']
    when :confirmation then User::Token::TYPE_CONFIRMATION
    when :recovery then User::Token::TYPE_RECOVERY
    else User::Token::TYPE_LOGIN
    end
  end
end
