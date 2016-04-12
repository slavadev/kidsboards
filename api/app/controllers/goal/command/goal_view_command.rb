# View a goal command
class Goal::Command::GoalViewCommand < Core::Command
  attr_accessor :id

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { Goal::Goal.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { Goal::Goal.find_by(id: x.id) }

  # Runs command
  # @return [Hash]
  def execute
    goal = Goal::Goal.find_by(id: id)
    goal.full_info
  end
end
