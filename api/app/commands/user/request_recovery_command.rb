# Request password recovery command
class User::RequestRecoveryCommand < Core::Command
  attr_accessor :email

  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  # Sets all services
  # @param [Object] params
  # @see User::UserRepository
  # @see User::TokenRepository
  # @see User::MailerService
  def initialize(params)
    super(params)
    @user_repository = User::UserRepository.get
    @token_repository = User::TokenRepository.get
    @mailer_service = User::MailerService.get
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: nil }
  end

  # Runs command
  def execute
    user = @user_repository.find_by_email(email)
    return if user.nil?
    token = User::Token.new(user, User::Token::TYPE_RECOVERY)
    token = @token_repository.save!(token)
    @mailer_service.send_recovery(user.email, token.code)
    nil
  end
end
