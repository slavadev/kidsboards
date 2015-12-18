# Family controller
class Family::FamilyController < Core::Controller
  # Update family info
  # @see Family::Command::UpdateCommand
  def update
    command = Family::Command::UpdateCommand.new(params)
    run(command)
  end
end
