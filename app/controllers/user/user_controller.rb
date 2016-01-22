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

  # Method for confirm
  # @see User::Command::ConfirmCommand
  def confirm
    command = User::Command::ConfirmCommand.new(params)
    run(command)
  end

  # Method for request password recovery
  # @see User::Command::RequestRecoveryCommand
  def request_recovery
    command = User::Command::RequestRecoveryCommand.new(params)
    run(command)
  end

  # Method for password recovery
  # @see User::Command::RequestRecoveryCommand
  def recovery
    command = User::Command::RecoveryCommand.new(params)
    run(command)
  end

  # Method for setting the pin
  # @see User::Command::PinSetCommand
  def pin_set
    command = User::Command::PinSetCommand.new(params)
    run(command)
  end

  # Method for checking the pin
  # @see User::Command::PinCheckCommand
  def pin_check
    command = User::Command::PinCheckCommand.new(params)
    run(command)
  end
end
