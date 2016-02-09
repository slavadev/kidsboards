# Photo controller
class File::PhotoController < Core::Controller
  # Creates a new image
  # @see File::Command::PhotoCreateCommand
  def create
    command = File::Command::PhotoCreateCommand.new(params)
    run(command)
  end

  # Gets list of photos
  # @see File::Command::PhotoIndexCommand
  def index
    command = File::Command::PhotoIndexCommand.new(params)
    run(command)
  end

  # Deletes a photo
  # @see File::Command::PhotoDeleteCommand
  def delete
    command = File::Command::PhotoDeleteCommand.new(params)
    run(command)
  end
end
