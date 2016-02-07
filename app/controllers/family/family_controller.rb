# Family controller
class Family::FamilyController < Core::Controller
  # Update family info
  # @see Family::Command::FamilyUpdateCommand
  def update
    command = Family::Command::FamilyUpdateCommand.new(params)
    run(command)
  end

  # View family info
  # @see Family::Command::FamilyViewCommand
  def view
    command = Family::Command::FamilyViewCommand.new(params)
    run(command)
  end
end
