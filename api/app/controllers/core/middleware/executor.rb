# Default executor for commands
class Core::Middleware::Executor < Core::Middleware
  # Runs a command
  # @return [[Core::Command], [Object]]
  def call
    [command, command.execute]
  end
end
