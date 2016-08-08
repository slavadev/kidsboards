# Photo index command
class Uploaded::Command::PhotoIndexCommand < Core::Command
  attr_accessor :authorization_service, :photo_service

  # Sets all services
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Uploaded::Repository::PhotoRepository
  # @see Uploaded::Presenter::PhotoPresenter
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.get
    @photo_repository = Uploaded::Repository::PhotoRepository.get
    @photo_presenter = Uploaded::Presenter::PhotoPresenter.get
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
