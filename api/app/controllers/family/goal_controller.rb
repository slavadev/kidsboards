# Goal controller
class Family::GoalController < Core::Controller
  # Creates a new goal
  # @see Goal::GoalCreateCommand
  def create
    command = Goal::GoalCreateCommand.new(params)
    run(command)
  end

  # Gets list of goals
  # @see Goal::GoalIndexCommand
  def index
    command = Goal::GoalIndexCommand.new(params)
    run(command)
  end
end
