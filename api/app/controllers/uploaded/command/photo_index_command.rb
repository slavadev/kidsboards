# Photo index command
class Uploaded::Command::PhotoIndexCommand < Core::Command
  attr_accessor :authorization_service, :photo_service

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
    photos = @photo_repository.find_actual_by_user(user)
    photos = photos.map { |photo| Uploaded::Presenter::PhotoPresenter.new(photo).photo_to_hash }
    { photos: photos }
  end
end
