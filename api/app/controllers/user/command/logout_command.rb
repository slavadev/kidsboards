# Logout command
class User::Command::LogoutCommand < Core::Command
  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see User::Repository::TokenRepository
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @token_repository = User::Repository::TokenRepository.new
  end

  # Runs command
  def execute
    token = @authorization_service.get_token_by_code_and_type(self.token, User::Token::TYPE_LOGIN)
    token.expire
    @token_repository.save!(token)
    nil
  end
end
