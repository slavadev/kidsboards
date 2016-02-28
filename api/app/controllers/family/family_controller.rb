# Family controller
class Family::FamilyController < Core::Controller
  # Updates family info
  # @see Family::Command::FamilyUpdateCommand
  def update
    command = Family::Command::FamilyUpdateCommand.new(params)
    run(command)
  end

  # Views family info
  # @see Family::Command::FamilyViewCommand
  def view
    command = Family::Command::FamilyViewCommand.new(params)
    run(command)
  end
end
