# Register command
class User::Command::RegisterCommand < Core::Command
  # Inizializator
  # @param [User::Input::RegisterInput] input
  def initialize(input)
    user = User::User.new
    user.email = input.email
    user.password = input.password
    user.save
    self.status = 200
    self.response = user
  end
end