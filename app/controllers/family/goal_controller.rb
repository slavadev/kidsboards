# Goal controller
class Family::GoalController < Core::Controller
  # Method for a new goal
  # @see Goal::Command::GoalCreateCommand
  def create
    command = Goal::Command::GoalCreateCommand.new(params)
    run(command)
  end

  # Method for getting list of goals
  # @see Goal::Command::GoalIndexCommand
  def index
    command = Goal::Command::GoalIndexCommand.new(params)
    run(command)
  end
end
