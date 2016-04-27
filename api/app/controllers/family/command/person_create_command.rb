# Create a person(an adult or a child) command
class Family::Command::PersonCreateCommand < Core::Command
  attr_accessor :name, :photo_url, :model

  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

  # Sets all variables
  # @param [Object] params
  # @see User::Service::AuthorizationService
  # @see Family::Factory::PersonFactory
  # @see Family::Repository::PersonRepository
  def initialize(params)
    super(params)
    @authorization_service = User::Service::AuthorizationService.new
    @person_factory = Family::Factory::PersonFactory.new(model)
    @person_repository = Family::Repository::PersonRepository.new(model)
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    person = @person_factory.create(user, name, photo_url)
    person = @person_repository.save!(person)
    { id: person.id }
  end
end
