# Contains basic methods to work with photos
class Uploaded::Service::PhotoService < Core::Service
  # Sets all variables
  # @see Uploaded::Photo
  def initialize
    @model = Uploaded::Photo
  end

  # Generates a photo
  # @param [User::User] user
  # @param [Object] file
  # @return [Uploaded::Photo]
  def create(user, file)
    model = @model.new
    model.user = user
    model.file = file
    model
  end

  # Converts attributes to hash
  # @param [Uploaded::Photo] photo
  # @return [Hash]
  def photo_to_hash(photo)
    {
      id: photo.id,
      url: ENV['UPLOAD_HOST'] + photo.file.url
    }
  end
end
