# Photo controller
class Uploaded::PhotoController < Core::Controller
  # Creates a new image
  # @see Uploaded::Command::PhotoCreateCommand
  def create
    command = Uploaded::Command::PhotoCreateCommand.new(params)
    run(command)
  end

  # Gets list of photos
  # @see Uploaded::Command::PhotoIndexCommand
  def index
    command = Uploaded::Command::PhotoIndexCommand.new(params)
    run(command)
  end

  # Deletes a photo
  # @see Uploaded::Command::PhotoDeleteCommand
  def delete
    command = Uploaded::Command::PhotoDeleteCommand.new(params)
    run(command)
  end
end
