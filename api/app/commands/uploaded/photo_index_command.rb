# Photo index command
class Uploaded::PhotoIndexCommand < Core::Command
  attr_accessor :authorization_service, :photo_service

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
    photos = @photo_repository.find_actual_by_user(user)
    photos = photos.map { |photo| @photo_presenter.photo_to_hash(photo) }
    { photos: photos }
  end
end
