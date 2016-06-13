# Contains methods to work with goals
class Goal::Service::GoalService
  # Adds or removes points
  # @param [Goal::Goal] goal
  # @param [Family::Adult] adult
  # @param [int] diff
  # @return [int]
  def change_points(goal, adult, diff)
    real_diff = goal.change_points(diff)
    action = Goal::Action.new(goal.user, goal, adult, real_diff)
    action.save!
    goal
  end
end
