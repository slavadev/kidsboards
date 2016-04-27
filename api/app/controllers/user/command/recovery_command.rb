# Recovery command
class User::Command::RecoveryCommand < Core::Command
  attr_accessor :password

  validates :password, presence: true
  validates :password, length: { minimum: 6 }

  # Sets all services
  # @param [Object] params
  # @see User::Repository::UserRepository
  # @see User::Repository::TokenRepository
  # @see User::Service::AuthorizationService
  def initialize(params)
    super(params)
    @user_repository = User::Repository::UserRepository.new
    @token_repository = User::Repository::TokenRepository.new
    @authorization_service = User::Service::AuthorizationService.new
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
