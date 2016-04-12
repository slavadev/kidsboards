# Register command
class User::Command::RegisterCommand < Core::Command
  attr_accessor :email, :password

  validates :email, :password, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, 'Core::Validator::Unique' => ->(x) { User::User.find_by(email: x.email)  }
  validates :password, length: { minimum: 6 }

  # Runs command
  # @return [Hash]
  def execute
    user = User::User.new
    user.email = email
    user.password = password
    user.confirmed_at = nil
    user.save
    token = User::Token.new(user, User::Token::TYPE_CONFIRMATION)
    token.save
    family = Family::Family.new(user)
    family.save
    Mailer.confirmation_email(user.email, token.code).deliver_later
    { id: user.id }
  end
end
