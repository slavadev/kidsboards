# Login command
class User::Command::LoginCommand < Core::Command
  attr_accessor :email, :password
  attr_accessor :user_service, :token_service

  validates :email, :password, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, length: { minimum: 6 }
  validate  :if_the_credentials_are_right

  # Sets all services
  # @param [Object] params
  # @see User::Service::UserService
  # @see User::Service::TokenService
  def initialize(params)
    super(params)
    @user_service = User::Service::UserService.new
    @token_service = User::Service::TokenService.new
  end

  # Checks if the email and password are right
  def if_the_credentials_are_right
    user = @user_service.find_by_email(email)
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
    user = @user_service.find_by_email(email)
    token = @token_service.create(user, User::Token::TYPE_LOGIN)
    token = @token_service.save!(token)
    { token: token.code }
  end
end
