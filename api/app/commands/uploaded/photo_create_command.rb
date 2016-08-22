# Photo create command
class Uploaded::PhotoCreateCommand < Core::Command
  attr_accessor :file

  validates :file, presence: true, 'Core::Validator::ContentType' => %r{\Aimage/.*\Z}

  # Sets all services
  # @param [Object] params
  # @see User::AuthorizationService
  # @see Uploaded::PhotoRepository
  # @see Uploaded::PhotoPresenter
  def initialize(params)
    super(params)
    @authorization_service = User::AuthorizationService.get
    @photo_repository = Uploaded::PhotoRepository.get
    @photo_presenter = Uploaded::PhotoPresenter.get
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    photo = Uploaded::Photo.new(user, file)
    photo = @photo_repository.save!(photo)
    @photo_presenter.photo_to_hash(photo)
  end
end
