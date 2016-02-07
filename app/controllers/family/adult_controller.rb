# Adult controller
class Family::AdultController < Core::Controller
  # Create adult
  # @see Family::Command::PersonCreateCommand
  def create
    params['model'] = Family::Adult
    command = Family::Command::PersonCreateCommand.new(params)
    run(command)
  end

  # Update adult
  # @see Family::Command::PersonUpdateCommand
  def update
    params['model'] = Family::Adult
    command = Family::Command::PersonUpdateCommand.new(params)
    run(command)
  end

  # Delete adult
  # @see Family::Command::PersonDeleteCommand
  def delete
    params['model'] = Family::Adult
    command = Family::Command::PersonDeleteCommand.new(params)
    run(command)
  end
end
