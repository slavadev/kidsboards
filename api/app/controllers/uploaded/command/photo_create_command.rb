# Photo create command
class Uploaded::Command::PhotoCreateCommand < Core::Command
  attr_accessor :file

  validates :file, presence: true, 'Core::Validator::ContentType' => %r{\Aimage/.*\Z}

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Uploaded::Repository::PhotoRepository
  # @see Uploaded::Factory::PhotoFactory
  # @see Uploaded::Viewer::PhotoViewer
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @photo_repository = Uploaded::Repository::PhotoRepository.new
    @photo_factory = Uploaded::Factory::PhotoFactory.new
    @photo_viewer = Uploaded::Viewer::PhotoViewer.new
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    photo = @photo_factory.create(user, file)
    photo = @photo_repository.save!(photo)
    @photo_viewer.photo_to_hash(photo)
  end
end
