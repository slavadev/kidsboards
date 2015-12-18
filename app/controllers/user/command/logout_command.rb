# Logout command
class User::Command::LogoutCommand < Core::Command
  # Run command
  def execute
    token = User::Token.where(code: self.token, type: User::Token::TYPE_LOGIN).first
    token.expire
    nil
  end
end
