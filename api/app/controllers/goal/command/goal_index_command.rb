# Command that shows a list of goals
class Goal::Command::GoalIndexCommand < Core::Command
  attr_accessor :id, :completed
  attr_accessor :person_repository

  validates :id,        presence: true,
                        'Core::Validator::Exists' => ->(x) { x.person_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_repository.find(x.id) }
  validates :completed, inclusion: [true, false, nil, 'false', 'true']

  # Sets all variables
  # @param [Object] params
  # @see Family:Child
  # @see Goal::Repository::GoalRepository
  # @see Goal::Service::GoalService
  # @see Goal::Viewer::GoalViewer
  # @see Family::Repository::PersonRepository
  # @see Family::Viewer::PersonViewerPersonViewer
  def initialize(params)
    super(params)
    @child_model = Family::Child
    @goal_repository = Goal::Repository::GoalRepository.new
    @goal_service = Goal::Service::GoalService.new
    @goal_viewer = Goal::Viewer::GoalViewer.new
    @person_repository = Family::Repository::PersonRepository.new(@child_model)
    @person_viewer = Family::Viewer::PersonViewer.new
  end

  # Runs command
  # @return [Hash]
  def execute
    child = @person_repository.find(id)
    is_completed = completed.nil? ? nil : completed == 'true'
    child_goals = @goal_service.get_goals_by_child(child, is_completed)
    goals = @person_viewer.child_goals_to_hash(child_goals)
    { goals: goals }
  end
end
