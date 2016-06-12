# Default executor for commands
class Core::Filter::Executor < Core::Filter
  # Runs a command
  # @return [[Core::Command], [Object]]
  def call
    [command, command.execute]
  end
end
