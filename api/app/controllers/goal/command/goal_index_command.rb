# Command that shows a list of goals
class Goal::Command::GoalIndexCommand < Core::Command
  attr_accessor :id, :completed
  attr_accessor :person_service, :goal_service

  validates :id,        presence: true,
                        'Core::Validator::Exists' => ->(x) { Family::Child.not_deleted.find_by(id: x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { Family::Child.find_by(id: x.id) }
  validates :completed, inclusion: [true, false, nil, 'false', 'true']

  # Sets all variables
  # @param [Object] params
  # @see Family:Child
  # @see Goal::Service::GoalService
  # @see Family::Service::PersonService
  def initialize(params)
    super(params)
    @child_model = Family::Child
    @goal_service = Goal::Service::GoalService.new
    @person_service = Family::Service::PersonService.new(@child_model)
  end


  # Runs command
  # @return [Hash]
  def execute
    child = @person_service.find(id)
    is_completed = completed.nil? ? nil : completed == 'true'
    child_goals = @goal_service.get_goals_by_child(child, is_completed)
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
      goals.push (@goal_service.goal_to_hash(goal))
    end
  end
end
