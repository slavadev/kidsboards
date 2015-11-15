# Registration params validation
class User::Input::RegisterInput < Core::Input
  attr_accessor :email, :password

  validates :email, :password, presence: true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :password, length: {minimum: 6}
  validate :user_doesnt_exists

  # Checks if the email is registred
  def user_doesnt_exists
    if User::User.where(email: email).exists?
      errors.add(:email, "User already exists")
    end
  end
end



