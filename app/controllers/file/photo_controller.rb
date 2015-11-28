# Photo controller
class File::PhotoController < Core::Controller

  # Method for new image
  # @see File::Command::PhotoCreateCommand
  def create
    command = File::Command::PhotoCreateCommand.new(params)
    run(command)
  end
end
