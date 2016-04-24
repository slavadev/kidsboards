# Photo index command
class Uploaded::Command::PhotoIndexCommand < Core::Command
  attr_accessor :authorization_service, :photo_service

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
    photos = @photo_service.find_actual_by_user(user)
    photos = photos.map { |photo| @photo_service.photo_to_hash(photo) }
    { photos: photos }
  end
end
