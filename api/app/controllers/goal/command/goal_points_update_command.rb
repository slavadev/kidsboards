# Command that updates goal's points
class Goal::Command::GoalPointsUpdateCommand < Core::Command
  attr_accessor :id, :diff, :adult_id

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { Goal::Goal.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { Goal::Goal.find_by(id: x.id) }
  validates :adult_id, presence: true,
                       'Core::Validator::Exists' => -> (x) { Family::Adult.find_actual_by_id_and_user(x.adult_id, x.current_user) }
  validates :diff,     numericality: { only_integer: true }

  # Runs command
  # @return [Hash]
  def execute
    goal, real_diff = update_goal
    create_action(goal, real_diff)
    { current: goal.current, target: goal.target }
  end

  # Gets current user
  # @return [User::User]
  def current_user
    User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
  end

  private

  # Updates a goal and returns a real diff of points
  # @return [Goal::Goal], [Integer]
  def update_goal
    goal = Goal::Goal.find_by(id: id)
    real_diff = goal.change_points(diff)
    goal.save!
    [goal, real_diff]
  end

  # Creates an action with information about goal's change
  # @param [Goal::Goal] goal
  # @param [Integer]    real_diff
  def create_action(goal, real_diff)
    user = User::User.get_user_by_token_code(token, User::Token::TYPE_LOGIN)
    adult = Family::Adult.find_by(id: adult_id)
    action = Goal::Action.new(user, goal, adult, real_diff)
    action.save
  end
end
