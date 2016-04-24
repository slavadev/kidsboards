# Recovery command
class User::Command::RecoveryCommand < Core::Command
  attr_accessor :password
  attr_accessor :user_service, :token_service, :authorization_service

  validates :password, presence: true
  validates :password, length: { minimum: 6 }

  # Sets all services
  # @param [Object] params
  # @see User::Service::UserService
  # @see User::Service::TokenService
  # @see User::Service::AuthorizationService
  def initialize(params)
    super(params)
    @user_service = User::Service::UserService.new
    @token_service = User::Service::TokenService.new
    @authorization_service = User::Service::AuthorizationService.new
  end

  # Runs command
  def execute
    token = @authorization_service.get_token_by_code_and_type(self.token, User::Token::TYPE_RECOVERY)
    token = @token_service.expire(token)
    token = @token_service.save!(token)
    user = token.user
    user.password = password
    @user_service.save!(user)
    nil
  end
end
