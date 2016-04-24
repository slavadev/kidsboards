# Contains methods to work with tokens and users
class User::Service::AuthorizationService
  # Sets all variables
  # @see User::Token
  def initialize
    @token_model = User::Token
  end

  # Gets the token for command according to authorization rules
  # @param [Core::Command] command
  # @return [User::Token]
  # @raise Core::Errors::UnauthorizedError
  def get_token_by_command(command)
    rule = get_rule_by_command(command)
    return if rule.blank?
    code = command.token
    fail Core::Errors::UnauthorizedError if code.nil?
    type  = get_token_type_by_rule(rule)
    get_token_by_code_and_type(code, type)
  end

  # Gets the rule for the command from rules file
  # @param [Core::Command] command
  def get_rule_by_command(command)
    rules = Rails.configuration.authorization_rules
    rules.select { |rule| rule['action'] == command.class.name }
  end

  # Gets type of the token
  # @param [Hash] rule
  # @return [Integer]
  def get_token_type_by_rule(rule)
    case rule[0]['token']
      when :confirmation then
        User::Token::TYPE_CONFIRMATION
      when :recovery then
        User::Token::TYPE_RECOVERY
      else
        User::Token::TYPE_LOGIN
    end
  end

  # Gets token by code and type
  # @param [Integer] code
  # @param [Integer] type
  # @return [User::Token]
  # @raise Core::Errors::UnauthorizedError
  def get_token_by_code_and_type(code, type)
    token = @token_model.where(code: code, token_type: type).first
    fail Core::Errors::UnauthorizedError if token.nil?
    token
  end

  # Gets a user by token code and type
  # @param [String] code
  # @param [Integer] type
  # @return [User::User]
  def get_user_by_token_code_and_type(code, type)
    token = get_token_by_code_and_type(code, type)
    token.user
  end

  # Gets a user by token code with default type
  # @param [String] code
  # @return [User::User]
  def get_user_by_token_code(code)
    get_user_by_token_code_and_type(code, User::Token::TYPE_LOGIN)
  end
end
