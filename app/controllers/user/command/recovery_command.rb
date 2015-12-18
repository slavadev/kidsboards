# Recovery command
class User::Command::RecoveryCommand < Core::Command
  attr_accessor :password

  validates :password, presence: true
  validates :password, length: { minimum: 6 }

  # Run command
  def execute
    token = User::Token.where(code: self.token, type: User::Token::TYPE_RECOVERY).first
    token.expire
    user = token.user
    user.password = password
    user.save
  end
end
