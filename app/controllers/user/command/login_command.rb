# Login command
class User::Command::LoginCommand < Core::Command
  attr_accessor :email, :password

  validates :email, :password, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, length: { minimum: 6 }
  validate  :if_the_credentials_are_right

  # Checks if the email and password are right
  def if_the_credentials_are_right
    if User::User.where(email: email).exists?
      user = User::User.where(email: email).first
      unless user.password_is_right? password
        errors.add(:email, 'Wrong email or password')
      end
    else
      errors.add(:email, 'Wrong email or password')
    end
  end

  # Runs command
  # @return [Hash]
  def execute
    user = User::User.where(email: email).first
    token = User::Token.new(user, User::Token::TYPE_LOGIN)
    token.save
    { token: token.code }
  end
end
