# Delete a person(an adult or a child) command
class Family::PersonDeleteCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model
  attr_accessor :person_repository

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.person_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_repository.find(x.id) }

  # Sets all variables
  # @param [Object] params
  # @see User::AuthorizationService
  # @see Family::PersonRepository
  def initialize(params)
    super(params)
    @authorization_service = User::AuthorizationService.get
    @person_repository = Family::PersonRepository.get(model)
  end

  # Runs command
  def execute
    person = @person_repository.find(id)
    @person_repository.delete(person)
    nil
  end
end
