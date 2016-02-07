# Child controller
class Family::ChildController < Core::Controller
  # Create child
  # @see Family::Command::PersonCreateCommand
  def create
    params['model'] = Family::Child
    command = Family::Command::PersonCreateCommand.new(params)
    run(command)
  end

  # Update child
  # @see Family::Command::PersonUpdateCommand
  def update
    params['model'] = Family::Child
    command = Family::Command::PersonUpdateCommand.new(params)
    run(command)
  end

  # Delete child
  # @see Family::Command::PersonDeleteCommand
  def delete
    params['model'] = Family::Child
    command = Family::Command::PersonDeleteCommand.new(params)
    run(command)
  end
end
