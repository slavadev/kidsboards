# Command that shows a list of goals
class Goal::Command::GoalIndexCommand < Core::Command
  attr_accessor :id, :completed

  validates :id,        presence: true,
                        'Core::Validator::Exists' => ->(x) { { id: x.id, deleted_at: nil } }
  validates :completed, inclusion: [true, false, nil, 'false', 'true']

  # Runs command
  # @return [Hash]
  def execute
    child = Family::Child.where(id: id).first
    is_completed = completed.nil? ? nil : completed == 'true'
    child_goals = child.get_goals(is_completed)
    goals = prepare_goals(child_goals)
    { goals: goals }
  end

  # Prepares goals to show to the user
  # @param [Array] child_goals
  # @return [Array]
  def prepare_goals(child_goals)
    return [] if child_goals.nil?
    goals = []
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
    goals
  end

  # Gets the model to validate
  # @return [Class]
  def model_to_validate
    Family::Child
  end
end
