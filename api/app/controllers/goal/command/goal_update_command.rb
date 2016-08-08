# Update a goal command
class Goal::Command::GoalUpdateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :target
  attr_accessor :goal_repository

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { x.goal_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.goal_repository.find(x.id) }
  validates :name,      length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true
  validates :target,    numericality: {
                                        only_integer: true,
                                        greater_than: 0,
                                        less_than: 1000
                                      }, allow_nil: true

  # Sets all variables
  # @param [Object] params
  # @see Goal::Repository::GoalRepository
  def initialize(params)
    super(params)
    @goal_repository = Goal::Repository::GoalRepository.get
  end

  # Runs command
  # @return [Hash]
  def execute
    goal = @goal_repository.find(id)
    goal.name = name unless name.nil?
    goal.photo_url = photo_url unless photo_url.nil?
    goal.target = target unless target.nil?
    @goal_repository.save!(goal)
    nil
  end
end
