# Contains basic methods to work with goals
class Goal::Service::GoalService < Core::Service
  include Goal::Service::GoalServiceCreateMethods
  include Goal::Service::GoalServiceReadMethods
  include Goal::Service::GoalServiceUpdateMethods

  # Sets all variables
  # @see Goal::Goal
  # @see Family::Child
  # @see Goal::Action
  def initialize
    @model = Goal::Goal
    @child_model = Family::Child
    @action_model = Goal::Action
  end
end
