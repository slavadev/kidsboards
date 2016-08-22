# Confirm command
class User::ConfirmCommand < Core::Command
  # Sets all services
  # @param [Object] params
  # @see User::AuthorizationService
  # @see User::UserRepository
  # @see User::TokenRepository
  def initialize(params)
    super(params)
    @authorization_service = User::AuthorizationService.get
    @user_repository = User::UserRepository.get
    @token_repository = User::TokenRepository.get
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
