# Photo controller
class Uploaded::PhotoController < Core::Controller
  # Creates a new image
  # @see Uploaded::PhotoCreateCommand
  def create
    command = Uploaded::PhotoCreateCommand.new(params)
    run(command)
  end

  # Gets list of photos
  # @see Uploaded::PhotoIndexCommand
  def index
    command = Uploaded::PhotoIndexCommand.new(params)
    run(command)
  end

  # Deletes a photo
  # @see Uploaded::PhotoDeleteCommand
  def delete
    command = Uploaded::PhotoDeleteCommand.new(params)
    run(command)
  end
end
