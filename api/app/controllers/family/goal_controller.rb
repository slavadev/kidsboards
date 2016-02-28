# Goal controller
class Family::GoalController < Core::Controller
  # Creates a new goal
  # @see Goal::Command::GoalCreateCommand
  def create
    command = Goal::Command::GoalCreateCommand.new(params)
    run(command)
  end

  # Gets list of goals
  # @see Goal::Command::GoalIndexCommand
  def index
    command = Goal::Command::GoalIndexCommand.new(params)
    run(command)
  end
end
