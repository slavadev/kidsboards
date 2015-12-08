# Photo controller
class File::PhotoController < Core::Controller
  # Method for new image
  # @see File::Command::PhotoCreateCommand
  def create
    command = File::Command::PhotoCreateCommand.new(params)
    run(command)
  end

  # Get list of photos
  # @see File::Command::PhotoIndexCommand
  def index
    command = File::Command::PhotoIndexCommand.new(params)
    run(command)
  end

  # Delete photo
  # @see File::Command::PhotoDeleteCommand
  def delete
    command = File::Command::PhotoDeleteCommand.new(params)
    run(command)
  end
end
