# Set pin command
class User::Command::PinSetCommand < Core::Command
  attr_accessor :token, :pin

  validates :pin, presence: true
  validates :pin, length: { is: 4 }
  validates :pin, format: { with: /\d{4}/,
                                    message: "has wrong format" }

  # Run command
  def execute
    user = User::User.get_user_by_token_code(self.token, User::Token::TYPE_LOGIN)
    user.pin = self.pin
    user.save
    nil
  end
end