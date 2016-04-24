# Request password recovery command
class User::Command::RequestRecoveryCommand < Core::Command
  attr_accessor :email
  attr_accessor :user_service, :token_service, :mailer_service

  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  # Sets all services
  # @param [Object] params
  # @see User::Service::UserService
  # @see User::Service::TokenService
  # @see User::Service::MailerService
  def initialize(params)
    super(params)
    @user_service = User::Service::UserService.new
    @token_service = User::Service::TokenService.new
    @mailer_service = User::Service::MailerService.new
  end

  # Runs command
  def execute
    user = @user_service.find_by_email(email)
    return if user.nil?
    token = @token_service.create(user, User::Token::TYPE_RECOVERY)
    token = @token_service.save!(token)
    @mailer_service.send_recovery(user.email, token.code)
    nil
  end
end
