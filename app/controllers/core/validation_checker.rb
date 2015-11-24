# Default validation checker
module Core::ValidationChecker
  # Check for validation
  # @param [Core::Command] command
  def valid? (command)
    if command.invalid?
      raise Core::Errors::ValidationError.new(command)
    end
  end
end