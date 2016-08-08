# Confirm command
class User::Command::ConfirmCommand < Core::Command
  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see User::Repository::UserRepository
  # @see User::Repository::TokenRepository
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.get
    @user_repository = User::Repository::UserRepository.get
    @token_repository = User::Repository::TokenRepository.get
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: :confirmation }
  end

  # Runs command
  def execute
    token = @authorization_service.get_token_by_code_and_type(self.token, User::Token::TYPE_CONFIRMATION)
    user = token.user
    user.confirm
    @user_repository.save!(user)
    token.expire
    @token_repository.save!(token)
  end
end
