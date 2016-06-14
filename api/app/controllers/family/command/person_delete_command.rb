# Delete a person(an adult or a child) command
class Family::Command::PersonDeleteCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model
  attr_accessor :person_repository

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.person_repository.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_repository.find(x.id) }

  # Sets all variables
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Family::Repository::PersonRepository
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @person_repository = Family::Repository::PersonRepository.new(model)
  end

  # Rules for authorization
  # @return [Hash]
  def authorization_rules
    { token_type: :login }
  end

  # Runs command
  def execute
    person = @person_repository.find(id)
    @person_repository.delete(person)
    nil
  end
end
