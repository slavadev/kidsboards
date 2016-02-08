# Delete a goal command
class Goal::Command::GoalDeleteCommand < Core::Command
  attr_accessor :id

  validates :id, presence: true,
                 'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }

  # Run command
  # @return [Hash]
  def execute
    goal = Goal::Goal.where(id: id).first
    goal.deleted_at = DateTime.now.utc
    goal.save
    nil
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    Goal::Goal
  end
end
