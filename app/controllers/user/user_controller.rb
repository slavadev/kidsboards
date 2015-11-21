# User controller
class User::UserController < Core::Controller

  # Method for registration
  # @see User::Command::RegisterCommand
  def register
    command = User::Command::RegisterCommand.new(params)
    run(command)
  end

  # Method for login
  # @see User::Command::LoginCommand
  def login
    command = User::Command::LoginCommand.new(params)
    run(command)
  end

  # Method for logout
  # @see User::Command::LogoutCommand
  def logout
    command = User::Command::LogoutCommand.new(params)
    run(command)
  end

end
