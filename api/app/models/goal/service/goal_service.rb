# Contains methods to work with goals
class Goal::Service::GoalService
  # Sets all variables
  # @see Goal::Goal
  # @see Family::Child
  # @see Goal::Action
  # @see Goal::Factory::GoalFactory
  def initialize
    @model = Goal::Goal
    @child_model = Family::Child
    @action_model = Goal::Action
    @goal_factory = Goal::Factory::GoalFactory.new
  end

  # Gets child goals
  # @param [Family::Child] child
  # @param [Boolean] completed
  # @return [Goal::Goal][] goals
  def get_goals_by_child(child, completed)
    goals = child.goals.not_deleted
    return goals if completed.nil?
    return goals.where('current >= target') if completed
    goals.where('current < target')
  end

  # Adds or removes points
  # @param [Goal::Goal] goal
  # @param [Family::Adult] adult
  # @param [int] diff
  # @return [int]
  def change_points(goal, adult, diff)
    real_diff = goal.change_points(diff)
    @goal_factory.create_action_and_save(goal.user, goal, adult, real_diff)
    goal
  end
end
