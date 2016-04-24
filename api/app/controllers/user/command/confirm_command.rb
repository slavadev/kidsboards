# Confirm command
class User::Command::ConfirmCommand < Core::Command
  attr_accessor :authorization_service, :token_service, :user_service

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see User::Service::UserService
  # @see User::Service::TokenService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @user_service = User::Service::UserService.new
    @token_service = User::Service::TokenService.new
  end

  # Runs command
  def execute
    token = @authorization_service.get_token_by_code_and_type(self.token, User::Token::TYPE_CONFIRMATION)
    user = token.user
    user = @user_service.confirm(user)
    @user_service.save!(user)
    token = @token_service.expire(token)
    @token_service.save!(token)
  end
end
