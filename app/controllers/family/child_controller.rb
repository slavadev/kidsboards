# Child controller
class Family::ChildController < Core::Controller
  # Creates a child
  # @see Family::Command::PersonCreateCommand
  def create
    params['model'] = Family::Child
    command = Family::Command::PersonCreateCommand.new(params)
    run(command)
  end

  # Updates a child
  # @see Family::Command::PersonUpdateCommand
  def update
    params['model'] = Family::Child
    command = Family::Command::PersonUpdateCommand.new(params)
    run(command)
  end

  # Deletes a child
  # @see Family::Command::PersonDeleteCommand
  def delete
    params['model'] = Family::Child
    command = Family::Command::PersonDeleteCommand.new(params)
    run(command)
  end
end
