# Contains methods to create goals
class Goal::Factory::GoalFactory
  # Sets all variables
  # @see Goal::Goal
  # @see Goal::Action
  def initialize
    @model = Goal::Goal
    @action_model = Goal::Action
  end

  # Creates a goal
  # @param [User::User]    user
  # @param [Family::Child] child
  # @param [Integer]       target
  # @param [String]        name
  def create(user, child, target, name, photo_url)
    model = @model.new
    model.user = user
    model.child = child
    model.target = target
    model.name = name
    model.photo_url = photo_url
    model.current = 0
    model
  end

  # Creates an action
  # @param [User::User]    user
  # @param [Goal::Gaol]    goal
  # @param [Family::Adult] adult
  # @param [Integer]       diff
  def create_action_and_save(user, goal, adult, diff)
    model = @action_model.new
    model.user = user
    model.goal = goal
    model.adult = adult
    model.diff = diff
    model.save!
  end
end
