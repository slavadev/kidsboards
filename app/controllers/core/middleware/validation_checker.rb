# Default validation checker
class Core::Middleware::ValidationChecker < Core::Middleware
  # Checks that command is valid
  # @return [Core::Command], [Object]
  # @raise Core::Errors::ValidationError
  def call
    fail(Core::Errors::ValidationError, command) if command.invalid?
    self.next
  end
end
