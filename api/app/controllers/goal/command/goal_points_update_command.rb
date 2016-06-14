# Command that updates goal's points
class Goal::Command::GoalPointsUpdateCommand < Core::Command
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
  # @see User::Service::AuthorizationService
  # @see Goal::Service::GoalService
  # @see Goal::Repository::GoalRepository
  # @see Family::Repository::PersonRepository
  def initialize(params)
    super(params)
    @adult_model = Family::Adult
    @authorization_service = User::Service::AuthorizationService.new
    @goal_service = Goal::Service::GoalService.new
    @goal_repository = Goal::Repository::GoalRepository.new
    @person_repository = Family::Repository::PersonRepository.new(@adult_model)
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: :login }
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
