# Family controller
class Family::FamilyController < Core::Controller
  # Update family info
  # @see Family::Command::FamilyUpdateCommand
  def family_update
    command = Family::Command::FamilyUpdateCommand.new(params)
    run(command)
  end

  # View family info
  # @see Family::Command::FamilyViewCommand
  def family_view
    command = Family::Command::FamilyViewCommand.new(params)
    run(command)
  end

  # Create adult
  # @see Family::Command::PersonCreateCommand
  def adult_create
    params['model'] = Family::Adult
    command = Family::Command::PersonCreateCommand.new(params)
    run(command)
  end

  # Update adult
  # @see Family::Command::PersonUpdateCommand
  def adult_update
    params['model'] = Family::Adult
    command = Family::Command::PersonUpdateCommand.new(params)
    run(command)
  end

  # Delete adult
  # @see Family::Command::PersonDeleteCommand
  def adult_delete
    params['model'] = Family::Adult
    command = Family::Command::PersonDeleteCommand.new(params)
    run(command)
  end

  # Create child
  # @see Family::Command::PersonCreateCommand
  def child_create
    params['model'] = Family::Child
    command = Family::Command::PersonCreateCommand.new(params)
    run(command)
  end

  # Update child
  # @see Family::Command::PersonUpdateCommand
  def child_update
    params['model'] = Family::Child
    command = Family::Command::PersonUpdateCommand.new(params)
    run(command)
  end

  # Delete child
  # @see Family::Command::PersonDeleteCommand
  def child_delete
    params['model'] = Family::Child
    command = Family::Command::PersonDeleteCommand.new(params)
    run(command)
  end
end
