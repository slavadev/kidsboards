# Contains methods to work with action entities
class Goal::ActionRepository < Core::Repository
  # Sets all variables
  # @see Goal::Action
  def initialize
    @model = Goal::Action
  end
end
