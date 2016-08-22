# Contains methods to work with goal entities
class Goal::GoalRepository < Core::Repository
  include Core::Deletable
  # Sets all variables
  # @see Goal::Goal
  def initialize
    @model = Goal::Goal
  end

  # Finds child goals
  # @param [Family::Child] child
  # @param [Boolean] completed
  # @return [Goal::Goal][] goals
  def find_goals_by_child(child, completed)
    goals = child.goals.not_deleted
    return goals if completed.nil?
    return goals.where('current >= target') if completed
    goals.where('current < target')
  end
end
