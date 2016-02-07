# List of goals
class Goal::Command::GoalIndexCommand < Core::Command
  attr_accessor :id, :completed

  validates :id,        presence: true,
                        'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }
  validates :completed, inclusion: [true, false, nil, 'false', 'true']

  # Run command
  # @return [Hash]
  def execute
    child = Family::Child.where(id: id).first
    goals = []
    is_completed = nil
    is_completed = (completed == 'true') unless completed.nil?
    child_goals = child.get_goals(is_completed)
    child_goals = [] if child_goals.nil?
    child_goals.each do |goal|
      item = {
        id: goal.id,
        name: goal.name,
        photo_url: goal.photo_url,
        target: goal.target,
        current: goal.current
      }
      goals.push item
    end
    { goals: goals }
  end

  # Get the model to validate
  # @return [Class]
  def model_to_validate
    Family::Child
  end
end
