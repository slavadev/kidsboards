# Update goal points
class Goal::Command::GoalPointsUpdateCommand < Core::Command
  attr_accessor :id, :diff, :adult_id

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }
  validates :adult_id, presence: true,
                       'Core::Validator::Exists' => { with: ->(x) { { id: x.adult_id, deleted_at: nil, user_id: x.get_current_user.id } },
                                                      model: Family::Adult
                                                    }
  validates :diff,     numericality: { only_integer: true }

  # Run command
  # @return [Hash]
  def execute
    goal, real_diff = create_goal
    create_action(goal, real_diff)
    { current: goal.current, target: goal.target }
  end

  # Creates a goal and returns a real diff of points
  # @return [Goal::Goal], [Integer]
  def create_goal
    goal = Goal::Goal.where(id: id).first
    goal.lock!
    real_diff = goal.current
    goal.current += diff.to_i
    goal.current = goal.target if goal.current > goal.target
    goal.current = 0 if goal.current < 0
    real_diff = goal.current - real_diff
    goal.save!
    [goal, real_diff]
  end

  # Creates an action with information about goal's change
  # @param [Goal::Goal] goal
  # @param [Integer]    real_diff
  def create_action(goal, real_diff)
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    adult = Family::Adult.find(adult_id)
    action = Goal::Action.new(user, goal, adult, real_diff)
    action.save
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    Goal::Goal
  end

  # Get current user
  # @return [User::User]
  def get_current_user
    User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
  end
end
