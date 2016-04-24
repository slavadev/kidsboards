# Contains basic methods to work with goals
class Goal::Service::GoalService < Core::Service
  # Sets all variables
  # @see Goal::Goal
  # @see Family::Child
  # @see Goal::Action
  def initialize
    @model = Goal::Goal
    @child_model = Family::Child
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
  def change_points(goal, adult,  diff)
    goal.lock!
    real_diff = goal.current
    goal.current += diff.to_i
    goal.current = goal.target if goal.current > goal.target
    goal.current = 0 if goal.current < 0
    real_diff = goal.current - real_diff
    create_action_and_save(goal.user, goal, adult, real_diff)
    goal
  end

  # Gets hash from goal
  # @param [Goal::Gaol] goal
  # @return [Hash]
  def goal_to_hash(goal)
    {
        id: goal.id,
        name: goal.name,
        photo_url: goal.photo_url,
        target: goal.target,
        current: goal.current
    }
  end

  # Gets hash with full info from goal
  # @param [Goal::Gaol] goal
  # @return [Hash]
  def goal_full_info(goal)
    {
        id: goal.id,
        name: goal.name,
        photo_url: goal.photo_url,
        target: goal.target,
        current: goal.current,
        created_at: goal.created_at,
        actions: get_actions(goal)
    }
  end

  private

  # Gets goal's actions
  # @param [Goal::Gaol] goal
  # @return [Hash]
  def get_actions(goal)
    goal.actions.map do |action|
      {
          adult: {
              id: action.adult.id,
              name: action.adult.name,
              photo_url: action.adult.photo_url
          },
          diff: action.diff,
          created_at: action.created_at
      }
    end
  end
end