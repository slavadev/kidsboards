# Logout command
class User::Command::LogoutCommand < Core::Command
  # Runs command
  def execute
    token = User::Token.where(code: self.token, token_type: User::Token::TYPE_LOGIN).first
    token.expire
    nil
  end
end
