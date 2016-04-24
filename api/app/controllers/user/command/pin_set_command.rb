# Set pin command
class User::Command::PinSetCommand < Core::Command
  attr_accessor :pin
  attr_accessor :authorization_service, :user_service

  validates :pin, presence: true
  validates :pin, length: { is: 4 }
  validates :pin, format: { with: /\d{4}/,
                            message: 'has wrong format' }

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see User::Service::UserService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @user_service = User::Service::UserService.new
  end

  # Runs command
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    user.pin = pin
    @user_service.save!(user)
    nil
  end
end
