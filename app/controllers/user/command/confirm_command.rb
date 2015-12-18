# Confirm command
class User::Command::ConfirmCommand < Core::Command
  # Run command
  def execute
    token = User::Token.where(code: self.token, type: User::Token::TYPE_CONFIRMATION).first
    user = token.user
    user.confirm
    token.expire
  end
end
