# Register command
class User::Command::RegisterCommand < Core::Command
  attr_accessor :email, :password
  attr_accessor :user_service, :token_service, :family_service, :mailer_service

  validates :email, :password, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, 'Core::Validator::Unique' => ->(x) { x.user_service.find_by_email(x.email) }
  validates :password, length: { minimum: 6 }

  # Sets all services
  # @param [Object] params
  # @see User::Service::UserService
  # @see User::Service::TokenService
  # @see Family::Service::FamilyService
  # @see User::Service::MailerService
  def initialize(params)
    super(params)
    @user_service = User::Service::UserService.new
    @token_service = User::Service::TokenService.new
    @family_service = Family::Service::FamilyService.new
    @mailer_service = User::Service::MailerService.new
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @user_service.create(email, password)
    user = @user_service.save!(user)
    token = @token_service.create(user, User::Token::TYPE_CONFIRMATION)
    @token_service.save!(token)
    family = @family_service.create(user)
    @family_service.save!(family)
    @mailer_service.send_confirmation(user.email, token.code)
    { id: user.id }
  end
end
