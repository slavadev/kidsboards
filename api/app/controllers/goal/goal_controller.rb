# Goal controller
class Goal::GoalController < Core::Controller
  # Shows a goal
  # @see Goal::GoalViewCommand
  def view
    command = Goal::GoalViewCommand.new(params)
    run(command)
  end

  # Updates a goal
  # @see Goal::GoalUpdateCommand
  def update
    command = Goal::GoalUpdateCommand.new(params)
    run(command)
  end

  # Deletes a goal
  # @see Goal::GoalDeleteCommand
  def delete
    command = Goal::GoalDeleteCommand.new(params)
    run(command)
  end

  # Adds or removes points
  # @see Goal::GoalPointsUpdateCommand
  def points_update
    command = Goal::GoalPointsUpdateCommand.new(params)
    run(command)
  end
end
