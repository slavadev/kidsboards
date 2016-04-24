# Command that updates goal's points
class Goal::Command::GoalPointsUpdateCommand < Core::Command
  attr_accessor :id, :diff, :adult_id
  attr_accessor :authorization_service, :person_service, :goal_service

  validates :id,       presence: true,
                       'Core::Validator::Exists' => ->(x) { x.goal_service.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.goal_service.find(x.id) }
  validates :adult_id, presence: true,
                       'Core::Validator::Exists' => -> (x) { x.person_service.find_actual_by_id_and_user(x.adult_id, x.current_user) }
  validates :diff,     numericality: { only_integer: true }

  # Sets all variables
  # @param [Object] params
  # @see Family:Adult
  # @see User::Service::AuthorizationService
  # @see Goal::Service::GoalService
  # @see Family::Service::PersonService
  def initialize(params)
    super(params)
    @adult_model = Family::Adult
    @authorization_service = User::Service::AuthorizationService.new
    @goal_service = Goal::Service::GoalService.new
    @person_service = Family::Service::PersonService.new(@adult_model)
  end

  # Runs command
  # @return [Hash]
  def execute
    goal = @goal_service.find(id)
    adult = @person_service.find(adult_id)
    goal = @goal_service.change_points(goal, adult, diff)
    goal = @goal_service.save!(goal)
    { current: goal.current, target: goal.target }
  end

  # Gets current user
  # @return [User::User]
  def current_user
    @authorization_service.get_user_by_token_code(token)
  end
end
