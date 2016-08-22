# Command that updates goal's points
class Goal::GoalPointsUpdateCommand < Core::Command
  attr_accessor :id, :diff, :adult_id
  attr_accessor :person_repository, :goal_repository

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { x.goal_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.goal_repository.find(x.id) }
  validates :adult_id, presence: true,
                       'Core::Validator::Exists' => -> (x) { x.person_repository.find_actual_by_id_and_user(x.adult_id, x.current_user) }
  validates :diff,     numericality: { only_integer: true }

  # Sets all variables
  # @param [Object] params
  # @see Family:Adult
  # @see User::AuthorizationService
  # @see Goal::GoalService
  # @see Goal::GoalRepository
  # @see Family::PersonRepository
  def initialize(params)
    super(params)
    @adult_model = Family::Adult
    @authorization_service = User::AuthorizationService.get
    @goal_service = Goal::GoalService.get
    @goal_repository = Goal::GoalRepository.get
    @person_repository = Family::PersonRepository.get(@adult_model)
  end

  # Runs command
  # @return [Hash]
  def execute
    goal = @goal_repository.find(id)
    adult = @person_repository.find(adult_id)
    goal = @goal_service.change_points(goal, adult, diff)
    goal = @person_repository.save!(goal)
    { current: goal.current, target: goal.target }
  end

  # Gets current user
  # @return [User::User]
  def current_user
    @authorization_service.get_user_by_token_code(token)
  end
end
