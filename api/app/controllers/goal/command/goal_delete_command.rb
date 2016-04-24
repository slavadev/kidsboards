# Delete a goal command
class Goal::Command::GoalDeleteCommand < Core::Command
  attr_accessor :id
  attr_accessor :goal_service

  validates :id, presence: true,
                 'Core::Validator::Exists' => ->(x) { x.goal_service.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.goal_service.find(x.id) }

  # Sets all variables
  # @param [Object] params
  # @see Goal::Service::GoalService
  def initialize(params)
    super(params)
    @goal_service = Goal::Service::GoalService.new
  end

  # Runs command
  # @return [Hash]
  def execute
    goal = @goal_service.find(id)
    @goal_service.delete(goal)
    nil
  end
end
