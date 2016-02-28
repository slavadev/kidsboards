# Contains methods to process data from authorization rules file
module Core::Authorization
  # Gets the token for command according to authorization rules
  # @param [Core::Command] command
  # @return [User::Token] token
  def get_token(command)
    rule = get_rule(command)
    return if rule.blank?
    token = command.token
    fail Core::Errors::UnauthorizedError if token.nil?
    type = get_type(rule)
    token = User::Token.where(code: token, token_type: type).first
    fail Core::Errors::UnauthorizedError if token.nil?
    token
  end

  # Gets the rule for the command from rules file
  # @param [Core::Command] command
  def get_rule(command)
    rules = Rails.configuration.authorization_rules
    rules.select { |rule| rule['action'] == command.class.name }
  end

  # Gets type of the token
  # @param [Hash] rule
  # @return [Integer]
  def get_type(rule)
    case rule[0]['token']
    when :confirmation then User::Token::TYPE_CONFIRMATION
    when :recovery then User::Token::TYPE_RECOVERY
    else User::Token::TYPE_LOGIN
    end
  end

  # Gets owner param
  # @param [Array] rule
  # @return [Boolean]
  def get_owner_param(rule)
    rule[0]['owner']
  end
end
