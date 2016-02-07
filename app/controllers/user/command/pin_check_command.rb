# Check pin command
class User::Command::PinCheckCommand < Core::Command
  attr_accessor :pin

  validates :pin, presence: true
  validates :pin, length: { is: 4 }
  validates :pin, format: { with: /\d{4}/,
                            message: 'has wrong format' }

  # Run command
  # @return [Hash]
  def execute
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    { equal: user.pin == pin }
  end
end
