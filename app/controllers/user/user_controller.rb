# User controller
class User::UserController < Core::Controller

  # Method for registration
  # @see User::Input::RegisterInput
  def register
    input = User::Input::RegisterInput.new(params)
    if check_validation(input)
      result = User::Command::RegisterCommand.new(input)
      render json:result.response, status:result.status
    end
  end

end
