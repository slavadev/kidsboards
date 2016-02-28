# Recovery command
class User::Command::RecoveryCommand < Core::Command
  attr_accessor :password

  validates :password, presence: true
  validates :password, length: { minimum: 6 }

  # Runs command
  def execute
    token = User::Token.where(code: self.token, token_type: User::Token::TYPE_RECOVERY).first
    token.expire
    user = token.user
    user.password = password
    user.save
    nil
  end
end
