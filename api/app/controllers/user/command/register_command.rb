# Register command
class User::Command::RegisterCommand < Core::Command
  attr_accessor :email, :password
  attr_accessor :user_repository

  validates :email, :password, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, 'Core::Validator::Unique' => ->(x) { x.user_repository.find_by_email(x.email) }
  validates :password, length: { minimum: 6 }

  # Sets all services
  # @param [Object] params
  # @see User::Repository::UserRepository
  # @see User::Repository::TokenRepository
  # @see Family::Repository::FamilyRepository
  # @see User::Service::MailerService
  def initialize(params)
    super(params)
    @user_repository = User::Repository::UserRepository.new
    @token_repository = User::Repository::TokenRepository.new
    @family_repository = Family::Repository::FamilyRepository.new
    @mailer_service = User::Service::MailerService.new
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: nil }
  end

  # Runs command
  # @return [Hash]
  def execute
    user = User::User.new(email, password)
    user = @user_repository.save!(user)
    token = User::Token.new(user, User::Token::TYPE_CONFIRMATION)
    @token_repository.save!(token)
    family = Family::Family.new(user)
    @family_repository.save!(family)
    @mailer_service.send_confirmation(user.email, token.code)
    { id: user.id }
  end
end
