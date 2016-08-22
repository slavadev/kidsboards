# Recovery command
class User::RecoveryCommand < Core::Command
  attr_accessor :password

  validates :password, presence: true
  validates :password, length: { minimum: 6 }

  # Sets all services
  # @param [Object] params
  # @see User::UserRepository
  # @see User::TokenRepository
  # @see User::AuthorizationService
  def initialize(params)
    super(params)
    @user_repository = User::UserRepository.get
    @token_repository = User::TokenRepository.get
    @authorization_service = User::AuthorizationService.get
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: :recovery }
  end

  # Runs command
  def execute
    token = @authorization_service.get_token_by_code_and_type(self.token, User::Token::TYPE_RECOVERY)
    token.expire
    token = @token_repository.save!(token)
    user = token.user
    user.password = password
    @user_repository.save!(user)
    nil
  end
end
