# Goal controller
class Goal::GoalController < Core::Controller
  # Shows a goal
  # @see Goal::Command::GoalViewCommand
  def view
    command = Goal::Command::GoalViewCommand.new(params)
    run(command)
  end

  # Updates a goal
  # @see Goal::Command::GoalUpdateCommand
  def update
    command = Goal::Command::GoalUpdateCommand.new(params)
    run(command)
  end

  # Deletes a goal
  # @see Goal::Command::GoalDeleteCommand
  def delete
    command = Goal::Command::GoalDeleteCommand.new(params)
    run(command)
  end

  # Adds or removes points
  # @see Goal::Command::GoalPointsUpdateCommand
  def points_update
    command = Goal::Command::GoalPointsUpdateCommand.new(params)
    run(command)
  end
end
