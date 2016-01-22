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
    rules = Rails.configuration.authorization_rules
    return if rules.select { |rule| rule['action'] == command.class.name }.blank?
    token = params['token']
    fail Core::Errors::UnauthorizedError if token.nil?
    type = get_type(rules, command)
    token = User::Token.where(code: token, token_type: type).first
    fail Core::Errors::UnauthorizedError if token.nil?
    token
  end

  # Get type of the token
  # @param [Array] rules
  # @param [Core::Command] command
  # @return [Integer]
  def get_type(rules, command)
    case rules.select { |rule| rule['action'] == command.class.name }[0]['token']
    when :confirmation then User::Token::TYPE_CONFIRMATION
    when :recovery then User::Token::TYPE_RECOVERY
    else User::Token::TYPE_LOGIN
    end
  end
end
