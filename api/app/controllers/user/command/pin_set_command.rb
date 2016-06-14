# Set pin command
class User::Command::PinSetCommand < Core::Command
  attr_accessor :pin

  validates :pin, presence: true
  validates :pin, length: { is: 4 }
  validates :pin, format: { with: /\d{4}/,
                            message: 'has wrong format' }

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see User::Repository::UserRepository
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @user_repository = User::Repository::UserRepository.new
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: :login }
  end

  # Runs command
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    user.pin = pin
    @user_repository.save!(user)
    nil
  end
end
