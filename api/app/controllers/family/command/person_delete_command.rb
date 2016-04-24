# Delete a person(an adult or a child) command
class Family::Command::PersonDeleteCommand < Core::Command
  attr_accessor :id, :name, :photo_url, :model
  attr_accessor :authorization_service, :person_service

  validates :id, presence: true, 'Core::Validator::Exists' => ->(x) { x.person_service.find_not_deleted(x.id) }
  validates :id, 'Core::Validator::Owner' => ->(x) { x.person_service.find(x.id) }

  # Sets all variables
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Family::Service::PersonService
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @person_service = Family::Service::PersonService.new(model)
  end

  # Runs command
  def execute
    person = @person_service.find(id)
    @person_service.delete(person)
    nil
  end
end
