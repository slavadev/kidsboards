# Default validation checker
class Core::Filter::ValidationChecker < Core::Filter
  # Checks that command is valid
  # @return [[Core::Command], [Object]]
  # @raise Core::Errors::ValidationError
  def call
    raise(Core::Errors::ValidationError, command) if command.invalid?
    self.next
  end
end
