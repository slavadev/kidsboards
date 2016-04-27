# Contains methods to work with goal entities
class Goal::Repository::GoalRepository < Core::Repository
  include Core::Deletable
  # Sets all variables
  # @see Goal::Goal
  def initialize
    @model = Goal::Goal
  end
end
