# Create a person(an adult or a child) command
class Family::PersonCreateCommand < Core::Command
  attr_accessor :name, :photo_url, :model

  validates :name,      presence: true, length: { maximum: 50 }
  validates :photo_url, length: { maximum: 100 }
  validates :photo_url, 'Core::Validator::Uri' => true

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
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    person = @model.new(user, name, photo_url)
    person = @person_repository.save!(person)
    { id: person.id }
  end
end
