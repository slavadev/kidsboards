# Adult controller
class Family::AdultController < Core::Controller
  # Creates an adult
  # @see Family::PersonCreateCommand
  def create
    params['model'] = Family::Adult
    command = Family::PersonCreateCommand.new(params)
    run(command)
  end

  # Updates an adult
  # @see Family::PersonUpdateCommand
  def update
    params['model'] = Family::Adult
    command = Family::PersonUpdateCommand.new(params)
    run(command)
  end

  # Deletes an adult
  # @see Family::PersonDeleteCommand
  def delete
    params['model'] = Family::Adult
    command = Family::PersonDeleteCommand.new(params)
    run(command)
  end
end
