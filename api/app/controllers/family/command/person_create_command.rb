# Create a person(an adult or a child) command
class Family::Command::PersonCreateCommand < Core::Command
  attr_accessor :name, :photo_url, :model
  attr_accessor :authorization_service, :person_service

  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

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
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    person = @person_service.create(user, name, photo_url)
    person = @person_service.save!(person)
    { id: person.id }
  end
end
