# Class needed to check that user is authorized
class Core::Middleware::AuthorizationChecker < Core::Middleware
  include Core::Authorization

  # Checks that user is authorized and calls next middleware
  # @return [[Core::Command], [Object]]
  def call
    get_token command
    self.next
  end
end
