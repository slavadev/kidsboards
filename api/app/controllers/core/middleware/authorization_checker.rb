# Class needed to check that user is authorized
class Core::Middleware::AuthorizationChecker < Core::Middleware
  # Sets all variables
  # @see User::Service::AuthorizationService
  def initialize
    @authorization_service = User::Service::AuthorizationService.new
  end

  # Checks that user is authorized and calls next middleware
  # @return [[Core::Command], [Object]]
  def call
    @authorization_service.get_token_by_command command
    self.next
  end
end
