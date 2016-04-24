# Create a goal command
class Goal::Command::GoalCreateCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :target
  attr_accessor :authorization_service, :person_service, :goal_service


  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.person_service.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_service.find(x.id) }
  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true
  validates :target,    presence: true,
                        numericality: {
                          only_integer: true,
                          greater_than: 0,
                          less_than: 1000
                        }

  # Sets all variables
  # @param [Object] params
  # @see Family:Child
  # @see User::Service::AuthorizationService
  # @see Goal::Service::GoalService
  # @see Family::Service::PersonService
  def initialize(params)
    super(params)
    @child_model = Family::Child
    @authorization_service = User::Service::AuthorizationService.new
    @goal_service = Goal::Service::GoalService.new
    @person_service = Family::Service::PersonService.new(@child_model)
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    child = @person_service.find(id)
    goal = @goal_service.create(user, child, target, name, photo_url)
    goal = @goal_service.save!(goal)
    { id: goal.id }
  end
end
