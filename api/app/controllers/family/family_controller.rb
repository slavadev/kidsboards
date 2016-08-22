# Family controller
class Family::FamilyController < Core::Controller
  # Updates family info
  # @see Family::FamilyUpdateCommand
  def update
    command = Family::FamilyUpdateCommand.new(params)
    run(command)
  end

  # Views family info
  # @see Family::FamilyViewCommand
  def view
    command = Family::FamilyViewCommand.new(params)
    run(command)
  end
end
