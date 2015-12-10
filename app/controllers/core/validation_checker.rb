# Default validation checker
module Core::ValidationChecker
  # Check for validation
  # @param [Core::Command] command
  def valid?(command)
    fail(Core::Errors::ValidationError, command) if command.invalid?
  end
end
