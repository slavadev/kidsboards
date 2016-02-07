# Goal controller
class Goal::GoalController < Core::Controller
  # Method for view a goal
  # @see Goal::Command::GoalViewCommand
  def view
    command = Goal::Command::GoalViewCommand.new(params)
    run(command)
  end

  # Method for update a goal
  # @see Goal::Command::GoalUpdateCommand
  def update
    command = Goal::Command::GoalUpdateCommand.new(params)
    run(command)
  end

  # Method for delete a goal
  # @see Goal::Command::GoalDeleteCommand
  def delete
    command = Goal::Command::GoalDeleteCommand.new(params)
    run(command)
  end

  # Method for adding or removing points
  # @see Goal::Command::GoalPointsUpdateCommand
  def points_update
    command = Goal::Command::GoalPointsUpdateCommand.new(params)
    run(command)
  end
end
