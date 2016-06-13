# Login command
class User::Command::LoginCommand < Core::Command
  attr_accessor :email, :password

  validates :email, :password, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, length: { minimum: 6 }
  validate  :if_the_credentials_are_right

  # Sets all services
  # @param [Object] params
  # @see User::Repository::UserRepository
  # @see User::Repository::TokenRepository
  def initialize(params)
    super(params)
    @user_repository = User::Repository::UserRepository.new
    @token_repository = User::Repository::TokenRepository.new
  end

  # Checks if the email and password are right
  def if_the_credentials_are_right
    user = @user_repository.find_by_email(email)
    if user
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
    user = @user_repository.find_by_email(email)
    token = User::Token.new(user, User::Token::TYPE_LOGIN)
    token = @token_repository.save!(token)
    { token: token.code }
  end
end
