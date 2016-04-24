# Check pin command
class User::Command::PinCheckCommand < Core::Command
  attr_accessor :pin
  attr_accessor :authorization_service

  validates :pin, presence: true
  validates :pin, length: { is: 4 }
  validates :pin, format: { with: /\d{4}/,
                            message: 'has wrong format' }

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    { equal: user.pin == pin }
  end
end
