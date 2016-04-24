# Contains update methods to work with goals
module Goal::Service::GoalServiceUpdateMethods
  # Adds or removes points
  # @param [Goal::Goal] goal
  # @param [Family::Adult] adult
  # @param [int] diff
  # @return [int]
  def change_points(goal, adult, diff)
    goal.lock!
    real_diff = goal.current
    goal.current += diff.to_i
    goal.current = goal.target if goal.current > goal.target
    goal.current = 0 if goal.current < 0
    real_diff = goal.current - real_diff
    create_action_and_save(goal.user, goal, adult, real_diff)
    goal
  end
end
