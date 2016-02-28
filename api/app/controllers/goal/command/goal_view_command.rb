# View a goal command
class Goal::Command::GoalViewCommand < Core::Command
  attr_accessor :id

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }

  # Runs command
  # @return [Hash]
  def execute
    goal = Goal::Goal.where(id: id).first
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

  # Gets the model to validate
  # @return [Class]
  def model_to_validate
    Goal::Goal
  end

  private

  # Gets goal's actions
  # @param [Goal::Goal] goal
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
