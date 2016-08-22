# Logout command
class User::LogoutCommand < Core::Command
  # Sets all services
  # @param [Object] params
  # @see User::AuthorizationService
  # @see User::TokenRepository
  def initialize(params)
    super(params)
    @authorization_service = User::AuthorizationService.get
    @token_repository = User::TokenRepository.get
  end

  # Runs command
  def execute
    token = @authorization_service.get_token_by_code_and_type(self.token, User::Token::TYPE_LOGIN)
    token.expire
    @token_repository.save!(token)
    nil
  end
end
