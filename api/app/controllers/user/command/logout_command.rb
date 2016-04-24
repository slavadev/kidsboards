# Logout command
class User::Command::LogoutCommand < Core::Command
  attr_accessor :authorization_service, :token_service

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see User::Service::TokenService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @token_service = User::Service::TokenService.new
  end

  # Runs command
  def execute
    token = @authorization_service.get_token_by_code_and_type(self.token, User::Token::TYPE_LOGIN)
    @token_service.expire(token)
    @token_service.save!(token)
    nil
  end
end
