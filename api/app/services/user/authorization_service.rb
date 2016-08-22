# Contains methods to work with tokens and users
class User::AuthorizationService < Core::Service
  # Sets all variables
  # @see User::TokenRepository
  def initialize
    @token_repository = User::TokenRepository.get
  end

  # Gets the token for command according to authorization rules
  # @param [Core::Command] command
  # @return [User::Token]
  # @raise Core::Errors::UnauthorizedError
  def get_token_by_command(command)
    rule = command.authorization_rules[:token_type]
    return if rule.nil?
    code = command.token
    raise Core::Errors::UnauthorizedError if code.nil?
    type = get_token_type_by_rule(rule)
    get_token_by_code_and_type(code, type)
  end

  # Checks rules for commands
  # @param [Core::Command] command
  def check_rules_for_command(command)
    get_token_by_command(command)
  end

  # Gets type of the token
  # @param [Hash] rule
  # @return [Integer]
  def get_token_type_by_rule(rule)
    case rule
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
    token = @token_repository.find_token_by_code_and_type(code, type)
    raise Core::Errors::UnauthorizedError if token.nil?
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
