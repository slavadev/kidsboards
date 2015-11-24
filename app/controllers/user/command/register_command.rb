# Register command
class User::Command::RegisterCommand < Core::Command
  attr_accessor :email, :password

  validates :email, :password, presence: true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :password, length: {minimum: 6}
  validate :user_doesnt_exists

  # Checks if the email is registered
  def user_doesnt_exists
    if User::User.where(email: email).exists?
      errors.add(:email, "User already exists")
    end
  end

  # Run command
  def execute
    user = User::User.new
    user.email = email
    user.password = password
    user.save
    token = User::Token.new(user, User::Token::TYPE_CONFIRMATION)
    token.save
    Mailer.confirmation_email(user.email, token.code).deliver_later
    {id: user['_id']}
  end
end