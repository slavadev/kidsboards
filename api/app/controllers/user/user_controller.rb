# User controller
class User::UserController < Core::Controller
  # Method for registration
  # @see User::RegisterCommand
  def register
    command = User::RegisterCommand.new(params)
    run(command)
  end

  # Method for login
  # @see User::LoginCommand
  def login
    command = User::LoginCommand.new(params)
    run(command)
  end

  # Method for logout
  # @see User::LogoutCommand
  def logout
    command = User::LogoutCommand.new(params)
    run(command)
  end

  # Method for confirm
  # @see User::ConfirmCommand
  def confirm
    command = User::ConfirmCommand.new(params)
    run(command)
  end

  # Method for request password recovery
  # @see User::RequestRecoveryCommand
  def request_recovery
    command = User::RequestRecoveryCommand.new(params)
    run(command)
  end

  # Method for password recovery
  # @see User::RequestRecoveryCommand
  def recovery
    command = User::RecoveryCommand.new(params)
    run(command)
  end

  # Method for setting the pin
  # @see User::PinSetCommand
  def pin_set
    command = User::PinSetCommand.new(params)
    run(command)
  end

  # Method for checking the pin
  # @see User::PinCheckCommand
  def pin_check
    command = User::PinCheckCommand.new(params)
    run(command)
  end

  # Method for the loader.io verification
  def loader
    render plain: 'loaderio-8fd226ca0551bbb679e5234f2b165e72'
  end
end
