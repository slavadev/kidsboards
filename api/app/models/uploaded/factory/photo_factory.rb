# Contains methods to create photos
class Uploaded::Factory::PhotoFactory
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
end
