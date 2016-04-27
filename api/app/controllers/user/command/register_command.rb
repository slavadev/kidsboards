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
  # @see User::Factory::UserFactory
  # @see User::Repository::UserRepository
  # @see User::Factory::TokenFactory
  # @see User::Repository::TokenRepository
  # @see Family::Factory::FamilyFactory
  # @see Family::Repository::FamilyRepository
  # @see User::Service::MailerService
  def initialize(params)
    super(params)
    @user_factory = User::Factory::UserFactory.new
    @user_repository = User::Repository::UserRepository.new
    @token_factory = User::Factory::TokenFactory.new
    @token_repository = User::Repository::TokenRepository.new
    @family_factory = Family::Factory::FamilyFactory.new
    @family_repository = Family::Repository::FamilyRepository.new
    @mailer_service = User::Service::MailerService.new
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @user_factory.create(email, password)
    user = @user_repository.save!(user)
    token = @token_factory.create(user, User::Token::TYPE_CONFIRMATION)
    @token_repository.save!(token)
    family = @family_factory.create(user)
    @family_repository.save!(family)
    @mailer_service.send_confirmation(user.email, token.code)
    { id: user.id }
  end
end
