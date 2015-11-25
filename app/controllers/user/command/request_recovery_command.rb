# Request password recovery command
class User::Command::RequestRecoveryCommand < Core::Command
  attr_accessor :email

  validates :email, presence: true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}

  # Run command
  def execute
    user = User::User.where(email: self.email).first
    return if user.nil?
    token = User::Token.new(user, User::Token::TYPE_RECOVERY)
    token.save
    Mailer.recovery_email(user.email, token.code).deliver_later
  end
end