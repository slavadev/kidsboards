# Contains methods to work with photo entities
class Uploaded::Repository::PhotoRepository < Core::Repository
  include Core::Deletable
  # Sets all variables
  # @see Uploaded::Photo
  def initialize
    @model = Uploaded::Photo
  end
end
