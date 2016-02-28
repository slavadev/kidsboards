# Adult controller
class Family::AdultController < Core::Controller
  # Creates an adult
  # @see Family::Command::PersonCreateCommand
  def create
    params['model'] = Family::Adult
    command = Family::Command::PersonCreateCommand.new(params)
    run(command)
  end

  # Updates an adult
  # @see Family::Command::PersonUpdateCommand
  def update
    params['model'] = Family::Adult
    command = Family::Command::PersonUpdateCommand.new(params)
    run(command)
  end

  # Deletes an adult
  # @see Family::Command::PersonDeleteCommand
  def delete
    params['model'] = Family::Adult
    command = Family::Command::PersonDeleteCommand.new(params)
    run(command)
  end
end
