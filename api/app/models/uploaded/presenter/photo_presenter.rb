# Contains basic methods to show photos
class Uploaded::Presenter::PhotoPresenter
  # Creates a presenter
  # @param [Uploaded::Photo] photo
  def initialize(photo)
    @photo = photo
  end

  # Converts attributes to hash
  # @return [Hash]
  def photo_to_hash
    {
      id: @photo.id,
      url: ENV['UPLOAD_HOST'] + @photo.file.url(:small)
    }
  end
end
