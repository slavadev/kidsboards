# Photo create command
class Uploaded::Command::PhotoCreateCommand < Core::Command
  attr_accessor :file

  validates :file, presence: true, 'Core::Validator::ContentType' => %r{\Aimage/.*\Z}

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Uploaded::Repository::PhotoRepository
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @photo_repository = Uploaded::Repository::PhotoRepository.new
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    photo = Uploaded::Photo.new(user, file)
    photo = @photo_repository.save!(photo)
    Uploaded::Presenter::PhotoPresenter.new(photo).photo_to_hash
  end
end
