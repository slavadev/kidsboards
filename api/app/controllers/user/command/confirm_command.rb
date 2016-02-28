# Confirm command
class User::Command::ConfirmCommand < Core::Command
  # Runs command
  def execute
    token = User::Token.where(code: self.token, token_type: User::Token::TYPE_CONFIRMATION).first
    user = token.user
    user.confirm
    token.expire
  end
end
