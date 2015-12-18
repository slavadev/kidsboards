# View command
class User::Command::ViewCommand < Core::Command
  # Run command
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    user.view
  end
end
