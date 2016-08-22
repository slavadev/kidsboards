# View a goal command
class Goal::GoalViewCommand < Core::Command
  attr_accessor :id
  attr_accessor :goal_repository

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.goal_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.goal_repository.find(x.id) }

  # Sets all variables
  # @param [Object] params
  # @see Goal::GoalRepository
  def initialize(params)
    super(params)
    @goal_repository = Goal::GoalRepository.get
    @goal_presenter = Goal::GoalPresenter.get
  end

  # Runs command
  # @return [Hash]
  def execute
    goal = goal_repository.find(id)
    @goal_presenter.goal_to_hash_with_full_info(goal)
  end
end
