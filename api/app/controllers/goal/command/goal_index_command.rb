# Command that shows a list of goals
class Goal::Command::GoalIndexCommand < Core::Command
  attr_accessor :id, :completed

  validates :id,        presence: true,
                        'Core::Validator::Exists' => ->(x) { Family::Child.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { Family::Child.find_by(id: x.id) }
  validates :completed, inclusion: [true, false, nil, 'false', 'true']

  # Runs command
  # @return [Hash]
  def execute
    child = Family::Child.find_by(id: id)
    is_completed = completed.nil? ? nil : completed == 'true'
    child_goals = child.get_goals(is_completed)
    goals = prepare_goals(child_goals)
    { goals: goals }
  end

  private

  # Prepares goals to show to the user
  # @param [Array] child_goals
  # @return [Array]
  def prepare_goals(child_goals)
    return [] if child_goals.nil?
    child_goals.inject([]) do |goals, goal|
      goals.push (goal.to_hash)
    end
  end
end
