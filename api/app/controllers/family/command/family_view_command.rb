# View a family command
class Family::Command::FamilyViewCommand < Core::Command
  attr_accessor :authorization_service

  # Sets all variables
  # @param [Object] params
  # @see Family::Child
  # @see User::Service::AuthorizationService
  # @see Family::Service::PersonService
  def initialize(params)
    super(params)
    model = Family::Child
    @authorization_service = User::Service::AuthorizationService.new
    @person_service = Family::Service::PersonService.new(model)
  end

  # Runs command
  # @return [Hash]
  def execute
    user = @authorization_service.get_user_by_token_code(token)
    family = user.family
    response = {}
    response['name'] = family.name
    response['photo_url'] = family.photo_url
    response['adults'] = get_persons user.adults.not_deleted
    response['children'] = get_persons user.children.not_deleted
    response
  end

  private

  # Gets persons
  # @param [Object] persons
  def get_persons(persons)
    response = []
    persons.each do |person|
      response.push(@person_service.person_to_hash(person))
    end
    response
  end
end
