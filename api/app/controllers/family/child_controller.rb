# Child controller
class Family::ChildController < Core::Controller
  # Creates a child
  # @see Family::PersonCreateCommand
  def create
    params['model'] = Family::Child
    command = Family::PersonCreateCommand.new(params)
    run(command)
  end

  # Updates a child
  # @see Family::PersonUpdateCommand
  def update
    params['model'] = Family::Child
    command = Family::PersonUpdateCommand.new(params)
    run(command)
  end

  # Deletes a child
  # @see Family::PersonDeleteCommand
  def delete
    params['model'] = Family::Child
    command = Family::PersonDeleteCommand.new(params)
    run(command)
  end
end
