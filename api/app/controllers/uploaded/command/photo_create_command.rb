# Photo create command
class Uploaded::Command::PhotoCreateCommand < Core::Command
  attr_accessor :file
  attr_accessor :authorization_service, :photo_service

  validates :file, presence: true, 'Core::Validator::ContentType' => %r{\Aimage/.*\Z}

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Uploaded::Service::PhotoService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @photo_service = Uploaded::Service::PhotoService.new
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    photo = @photo_service.create(user, file)
    photo = @photo_service.save!(photo)
    @photo_service.photo_to_hash(photo)
  end
end
