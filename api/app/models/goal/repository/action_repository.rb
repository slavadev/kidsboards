# Contains methods to work with action entities
class Goal::Repository::ActionRepository < Core::Repository
  include Core::Deletable
  # Sets all variables
  # @see Goal::Action
  def initialize
    @model = Goal::Action
  end
end
